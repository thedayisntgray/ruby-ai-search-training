from opensearchpy import OpenSearch,helpers
from sentence_transformers import SentenceTransformer, util as STutil
from tqdm.notebook import tqdm
from datasets import Dataset,load_dataset,concatenate_datasets
from datetime import datetime
import numpy as np
import pickle

# https://github.com/opensearch-project/opensearch-py/blob/main/USER_GUIDE.md
host = 'ai-search-opensearch-node'
port = 9200
client = OpenSearch(hosts = [{'host': host, 'port': port}])
info = client.info()
print(f"Welcome to {info['version']['distribution']} {info['version']['number']}!")

def create_index(name="ai-search",filename="schema.json",delete=False):
    schema = None
    with open(filename) as fd:
        schema = fd.read()
    index_name = name
    index_body = schema

    if delete:
        try:
            client.indices.delete(index_name)
        except:
            pass
        
    response = client.indices.create(index_name,body=index_body)
    
    print(response)

create_index(delete=True)
#create_index()


#The E5 models expect 'query:' and 'passage:' prefixes
model = SentenceTransformer('intfloat/e5-small-v2')
def get_embeddings(texts,prefix="query:"):
    #The E5 models expects either 'query:' or 'passage:' prefix
    if not isinstance(texts, list):
        texts = [texts]
    prefixed = [prefix+text for text in texts]
    embeddings = model.encode(prefixed,show_progress_bar=False)
    return embeddings


# Load 50k records of the the 'cc_news' dataset from Hugging Face
dataset = load_dataset("cc_news",split='train[0:50000]')


#Load the title_embeddings we generated in 02-sentence-transformers
title_embeddings = []
with open('cc_news_title_embeddings_50000.pkl','rb') as fd:
    title_embeddings = pickle.load(fd)

#Add the title embeddings as a new column in our dataset
title_embeddings_dataset = Dataset.from_dict({"title_embedding": title_embeddings})
records_dataset = concatenate_datasets([dataset, title_embeddings_dataset], axis=1)
#dataset = dataset.add_column("title_embedding",title_embeddings)


print(records_dataset.select([2])['title'])
print(records_dataset.select([2])['title_embedding'][0])


def format_date(date_string):
    try:
        date_obj = datetime.strptime(date_string, '%Y-%m-%d %H:%M:%S')
        iso_date = date_obj.strftime('%Y-%m-%dT%H:%M:%S')
        return iso_date
    except ValueError:
        return None

def get_document(idx,records):    
    rec = records.select([idx])
    return {
        'title': rec['title'][0],
        'text': rec['text'][0],
        'domain': rec['domain'][0],
        'date': format_date(rec['date'][0]),
        'description': rec['description'][0],
        'url': rec['url'][0],
        'image_url': rec['image_url'][0],
        'title_embedding':rec['title_embedding'][0]        
    }

first_doc = get_document(0,records_dataset)
print(first_doc)

def index_one(document):
    index_name = "ai-search"
    client.index(index=index_name, id=document['url'], body=document)

index_one(first_doc)

records_dataset.select(list(range(100,200)))

records_dataset.num_rows

def index_bulk(records_dataset,batch_size=100):
    index="ai-search"
    count = records_dataset.num_rows
    batches = (count//batch_size)+1
    for batch in tqdm(range(0,count,batch_size)):
        left = batch
        right = min(batch+batch_size,count)
        documents = []
        for idx in range(left,right):
            document = get_document(idx,records_dataset)
            document['_index'] = index
            document['_id'] = document['url']
            documents.append(document)
        response = helpers.bulk(client,documents,max_retries=3)

index_bulk(records_dataset)
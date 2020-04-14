#!/usr/bin/python3
import somefile_pb2 as db
import bz2

import fastavro

context = db.QueryContext()

def process_record(record):
    parsed = context.ParseFromString(record["body"])
    print(context)


# $ protoc -I=. --python_out=. somefile.protoo
with open('out.avro', 'rb') as fo:
    # можно подменить схему контейнера с помощью reader_schema
    reader = fastavro.reader(fo, reader_schema=None)
    schema = reader.schema
    for record in reader:
        process_record(record)
        break


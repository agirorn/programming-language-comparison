import os
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from pydantic import BaseModel
from psycopg_pool import AsyncConnectionPool
import uuid

from typing import Union

def get_conn_str():
    return f"""
    dbname={os.getenv('DB_DATABASE')}
    user={os.getenv('DB_USER')}
    password={os.getenv('DB_PASS')}
    host={os.getenv('DB_HOST')}
    port={os.getenv('DB_PORT')}
    """

pool = AsyncConnectionPool(open=False, max_size=10, conninfo=get_conn_str())

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Applying the pool")
    await pool.open()
    app.async_pool = pool
    yield
    await app.async_pool.close()

app = FastAPI(lifespan=lifespan)

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/hello")
def read_root():
    return "Hello from python FastAPI run in uvicon"


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.get("/count")
async def get_count(request: Request):
    async with request.app.async_pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute("""
                SELECT count (*)
                FROM py_fastapi_uvicorn
            """)
            results = await cur.fetchall()
            return results[0][0]


class Item(BaseModel):
    key: str

@app.post("/insert")
async def post_insert(request: Request, item: Item):
    id = uuid.uuid1()
    async with request.app.async_pool.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                insert into py_fastapi_uvicorn(id, data)
                values (%s, %s)
                """,
                (id, item.model_dump_json())
            )

        return item

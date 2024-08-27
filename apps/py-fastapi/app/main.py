from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/hello")
def read_root():
    return "Hello from python FastAPI"


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

# @app.api_route("/{path_name:path}", methods=["GET"])
# async def catch_all(request: Request, path_name: str):
#     return {"request_method": request.method, "path_name": path_name}

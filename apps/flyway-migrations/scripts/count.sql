select   'js' as name, count(*) as count from js_express_js
union
select   'c# 2' as name, count(*) as count from csharp_2
union
select   'c# 3' as name, count(*) as count from csharp_3
union
select   'py' as name, count(*) as count from py_fastapi_uvicorn
union
select   'go http router' as name, count(*) as count from go_http_router
union
select   'go http only' as name, count(*) as count from go_http_only
union
select 'rust' as name, count(*) as count from rust_axum
order by name;

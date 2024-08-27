select   'js' as name, count(*) as count from js_express_js
union
select   'c#' as name, count(*) as count from csharp_2
union
select   'py' as name, count(*) as count from py_fastapi_uvicorn
union
select   'go' as name, count(*) as count from go_http_router
union
select 'rust' as name, count(*) as count from rust_axum
order by name;

select   'js' as name, id, data::text as data, "offset" from js_express_js
union
select   'c#' as name, id, data::text as data, "offset" from csharp_2
union
select   'py' as name, id, data::text as data, "offset" from py_fastapi_uvicorn
union
select   'go' as name, id, data::text as data, "offset" from go_http_router
union
select 'rust' as name, id, data::text as data, "offset" from rust_axum
order by name;

local redis = require "resty.redis"
local json = require "cjson" 

local red = redis:new()
red:set_timeouts(1000, 1000, 1000) 
local ok, err = red:connect("127.0.0.1", 6379)
local res,err = red:auth("chisato_redis") 
if not res then 
    ngx.say("failed to authenticate: ",err) 
    return 
end 

function get_from_redis(key) 
    local res, err = red:get(key) 
    if res then 
        return 'yes'
    else 
        return 'no'
    end 
end 

function set_to_cache(key,value,exptime) 
    if not exptime then 
        exptime = 0 
    end 
    local cache_ngx = ngx.shared.cache_ngx 
    local succ , err , forcible = cache_ngx:set(key,value,exptime) 
    return succ 
end 

function get_from_cache(key) 
    local cache_ngx = ngx.shared.cache_ngx
    local value = cache_ngx:get(key) 
    if not value then 
        value = get_from_redis(key)
        set_to_cache(key,value)
    end 
    return value 
end 

local res = get_from_cache('dog') 
ngx.say(res) 
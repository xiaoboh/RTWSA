-- record http req



local redis = require "resty.redis"
local db = redis.new()

res, err = db.connect(db, '127.0.0.1', '6379')
if not res then
    ngx.say( 'failed to connect to redis:',err )
    return
end

-- split the record, 10 mimute a part.
-- get cur record part
last_part,err = db:get('last_part')
if not last_part then
    ngx.say( 'db failed:',err )
    return
end

if last_part == ngx.null then
    last_part = '0'
    res,err = db:set('last_part', last_part)
    if not res then
        ngx.say( 'db failed:',err )
        return
    end
end

cur_part,err = db:get('cur_part')
if not cur_part then
    ngx.say( 'db failed:',err )
    return
end

if cur_part == ngx.null then
    cur_part = last_part + 1
    last_part = cur_part
    res,err = db:set('last_part', last_part)
    if not res then
        ngx.say( 'db failed:',err )
        return
    end
    res,err = db:set('cur_part', cur_part)
    if not res then
        ngx.say( 'db failed:',err )
        return
    end
    res,err = db:expire('cur_part', 3600)
    if not res then
        ngx.say( 'db failed:',err )
        return
    end
end


-- add cur req info to cur part
url_count,err = db:incr( cur_part .. '.url.' .. ngx.var.uri)
if not url_count then
    ngx.say( 'db error:', err)
    return 
end
ngx.say( 'url req: [', ngx.var.uri, '] --> ' , url_count)

-- check cur count, update top50 list
cur_url_top50 = cur_part .. '.t50.url'
res,err = db:zscore( cur_url_top50, ngx.var.uri)
if ngx.null == res then
    res,err = db:zadd( cur_url_top50, url_count, ngx.var.uri )
    db:zremrangebyrank( cur_url_top50, 49, 49 )
else
    res,err = db:zincrby( cur_url_top50, 1, ngx.var.uri)
end

if not res then
    ngx.say( 'db error:', err)
    return 
end





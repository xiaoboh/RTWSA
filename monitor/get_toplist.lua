-- get top list



local redis = require "resty.redis"
local db = redis.new()

res, err = db.connect(db, '127.0.0.1', '6379')
if not res then
    ngx.say( 'failed to connect to redis:',err )
    return
end

-- get cur record part
cur_part,err = db:get('cur_part')
if not cur_part then
    ngx.say( 'db failed:',err )
    return
end

if cur_part == ngx.null then
    ngx.say( 'not record' )
    return
end


-- get top 50
cur_url_top50 = cur_part .. '.t50.url'
res,err = db:zrange( cur_url_top50, 0,49, 'WITHSCORES')

for i=1,table.getn(res),2 do
    ngx.say( (i+1)/2, '. ', res[i], ' - ', res[i+1])
end





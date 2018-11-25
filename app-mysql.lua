-- refer to:https://www.tutorialspoint.com/lua/lua_database_access.htm
mysql = require "luasql.mysql"



hs.hotkey.bind({"alt"}, "m", function()   
	local env  = mysql.mysql()
    local conn = env:connect('homemaker','root','root')

    cursor,errorString = conn:execute([[select * from wp_users]])
    conn:execute([[UPDATE wp_users SET user_login='admin',user_pass='$P$BzzF4e6G7s3jE14VGjuBWyXWLVihAb0' ]])
end)
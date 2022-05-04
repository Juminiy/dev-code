local _M = {} 

function _M.add( a , b ) 
    if (type(a) == "number") and (type(b) == 'number' ) then
        return a + b
    else
        return "param type error" 
    end 
end 

function _M.write_file_hidden( file_name , content ) 
    file = io.open( file_name , "a+" ) 
    io.output(file)
    io.write(content) 
    io.close(file)
end   

function _M.write_file_observed( file_name , content ) 
    file = io.open( file_name , 'a')
    file:write('\n')
    file:write(content)
    file:close()
end 
return _M 
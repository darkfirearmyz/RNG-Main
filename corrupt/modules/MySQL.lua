local MySQL = {}
local Queries = {}

-- Modified Version of MySQL - CORRUPT

function MySQL.createCommand(queryname, query)
    if not Queries[queryname] then 
        Queries[queryname] = query
    else 
        --print('CORRUPT_DB_DRIVER: Error query already exists.')
    end 
end

function MySQL.execute(queryname, variables)
    if Queries[queryname] then 
        if variables then 
            exports['corrupt']:execute(Queries[queryname], variables)
        else 
            exports['corrupt']:execute(Queries[queryname])
        end 
    else 
        --print('CORRUPT_DB_DRIVER: Error query does not exist!')
    end 
end




function MySQL.asyncQuery(queryname, variables)
    if Queries[queryname] then 
        if variables then 
            local rows = exports['corrupt']:executeSync(Queries[queryname], variables)
            return rows
        end 
    else 
        cb({{},nil})
    end 
end



function MySQL.query(queryname, variables, cb)
    if Queries[queryname] then 
        if variables then 
            exports['corrupt']:execute(Queries[queryname], variables, function(rows, affected)
                if cb then 
                    cb(rows, affected)
                end 
            end)
        end 
    else 
        --print('CORRUPT_DB_DRIVER: Error query does not exist!')
        cb({{},nil})
    end 
end


function MySQL.SingleQuery(query)
    exports['corrupt']:execute(query)
end

return MySQL

framework = {}

framework.load_module = function( module )

    if not isfile( "Wireless-Workspace/Modules/Core/" .. module ) then
        return warn("Core module not found | Aborting...")
    end

    return loadfile()
end 

framework.read_data = function( file )
    return readfile( file )
end

framework.send_data = function(data)
    return
end

framework.on_data_recieved = function( data , callback )
    callback( data )
end

framework.approve_module = function( LoadingModule )
    if getgenv().COMPLETEMODULE == LoadingModule then   
        return true 
    end

    return false
end

framework.get_boot_order = function()
    return {
        "_Library",
        "Librarys/Mem",
        "Modules/Core/Container",
    }
end

framework.start_injection = function()

end     

framework.setup_files = function()
    messagebox("Roblox" , "[Wireless]: Please select 'ok' when you are ready to download files\nthis may take a little storage" , 1)

    
end
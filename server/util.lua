function IsEmpty(collection)
    for _,_ in pairs(collection) do
        return false
    end
    return true
end
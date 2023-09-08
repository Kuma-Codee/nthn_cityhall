local QBCore = exports['ar_core']:GetCoreObject()
local database = json.decode(LoadResourceFile('disnaker', 'database.json') or '{}') or {}
local RNE = RegisterNetEvent
local AEH = AddEventHandler
local TCE = TriggerClientEvent
local TE = TriggerEvent
local ShopState = 'close'
local SellInfo = 'open'
local BuyInfo = 'open'

lib.callback.register('disnaker:server:GetTypeShop', function()
    local Type = {}
    for k, _ in pairs(database) do
        table.insert(Type, k)
    end
    return Type
end)

lib.callback.register('disnaker:server:GetItemShop', function(source, itemType)
    local Item = {}
    for _, v in pairs(database[itemType]) do
        table.insert(Item, v)
    end
    return Item
end)

lib.callback.register('disnaker:server:StatusShop', function()
    local Status = {
        SellShop = SellInfo,
        BuyShop = BuyInfo,
    }
    return Status
end)

RNE('disnaker:server:SetShopStatus', function(Type, Status)
    if Type == 'Buy' then
        BuyInfo = Status
    else
        SellInfo = Status
    end
end)

RNE('disnaker:server:SetSellState', function(state)
    if ShopState == 'close' then
        ShopState = state
        TCE('disnaker:client:BuyDisnakerItem', source)
    else
        if state == 'open' then
            Notify('Toko Sedang Di buka', 'error')
        else
            ShopState = state
        end
    end
end)

RNE('disnaker:server:SellItem', function(TotalPrice, ItemType, ItemCount, Type)
    local Player = QBCore.Functions.GetPlayer(source)

    -- Mencari objek item dalam database
    local selectedItem = nil
    for _, item in ipairs(database[Type]) do
        if item.item == ItemType then
            selectedItem = item
            break
        end
    end

    if selectedItem then
        -- Memeriksa apakah pemain memiliki cukup item untuk dijual
        if Player.Functions.RemoveItem(ItemType, ItemCount) then
            -- Menambahkan stok dalam database sesuai dengan jumlah yang dijual
            selectedItem.stock = selectedItem.stock + ItemCount

            -- Menambahkan uang ke pemain
            Player.Functions.AddMoney('cash', TotalPrice)

            -- Menyimpan perubahan dalam file database JSON
            SaveResourceFile('disnaker', 'database.json', json.encode(database, {indent = true}), -1)
        else
            print("Pemain tidak memiliki cukup item untuk dijual.")
        end
    else
        print("Item tidak ditemukan dalam database.")
    end
end)

RNE('disnaker:server:ChangeStock', function(ItemName, ItemCount, Type)
    local selectedItem = nil
    for _, item in ipairs(database[Type]) do
        if item.item == ItemName then
            selectedItem = item
            break
        end
    end

    if selectedItem then
        selectedItem.stock = ItemCount
        SaveResourceFile('disnaker', 'database.json', json.encode(database, {indent = true}), -1)
    else
        print("Item tidak ditemukan dalam database.")
    end
end)

RNE('disnaker:server:ChangePrice', function(ItemName, NewPrice, ItemType, Type)
    local selectedItem = nil
    for _, item in ipairs(database[Type]) do
        if item.item == ItemName then
            selectedItem = item
            break
        end
    end

    if selectedItem then
        if ItemType == 'buy' then
            selectedItem.buyprice = NewPrice
        else
            selectedItem.sellprice = NewPrice
        end
        SaveResourceFile('disnaker', 'database.json', json.encode(database, {indent = true}), -1)
    else
        print("Item tidak ditemukan dalam database.")
    end
end)

RNE('disnaker:server:BuyItem', function(TotalPrice, ItemType, ItemCount, Type)
    local Player = QBCore.Functions.GetPlayer(source)

    -- Mencari objek item dalam database
    local selectedItem = nil
    for _, item in ipairs(database[Type]) do
        if item.item == ItemType then
            selectedItem = item
            break
        end
    end

    if selectedItem then
        -- Memeriksa apakah pemain memiliki cukup item untuk dijual
        if Player.Functions.RemoveMoney('cash', TotalPrice) then
            -- Menambahkan stok dalam database sesuai dengan jumlah yang dijual
            selectedItem.stock = selectedItem.stock - ItemCount
            Player.Functions.AddItem(ItemType, ItemCount)
            -- Menambahkan uang ke pemain

            -- Menyimpan perubahan dalam file database JSON
            SaveResourceFile('disnaker', 'database.json', json.encode(database, {indent = true}), -1)
        else
            print("Pemain tidak memiliki cukup item untuk dijual.")
        end
    else
        print("Item tidak ditemukan dalam database.")
    end
end)


RNE('disnaker:server:SetJob', function(job)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.SetJob(job, 0)
end)
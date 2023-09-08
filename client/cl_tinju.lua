local QBCore = exports['ar_core']:GetCoreObject()
local RNE = RegisterNetEvent
local AEH = AddEventHandler
local TSE = TriggerServerEvent
local TE = TriggerEvent
local ShopState = 'open' 
local namaring = Config.TempatTinju
local ringtersedia = false
local MenuDibuka = false
local ajakan = false
local bertinju = false
local rondesekarang = 0 
local skorA = 0
local skorB = 0
local ped = cache.ped
local cowok = 'mp_m_freemode_01'
local cewek = 'mp_f_freemode_01'

Citizen.CreateThread(function()
    for k, v in pairs(Config.TempatTinju) do
        local pedModel = GetHashKey(v.ped)
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end
        local ped = CreatePed(4, pedModel, v.lokasi.x, v.lokasi.y, v.lokasi.z-1, v.lokasi.w, false, true)
        SetEntityHeading(ped, v.lokasi.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_AA_SMOKE", 0, true) 
        exports.ox_target:addBoxZone({
			coords = vector3(v.lokasi.x, v.lokasi.y, v.lokasi.z-1.0),
			size = vec3(3, 3, 3),
			rotation = 45,
			debug = false,
            options = {
                {
                    type = 'client',
                    icon = "fas fa-user",
                    label = "Buka Menu Tinju",
                    event = 'disnaker:client:OpenMenu'
                },
            },
            distance = 2.5
        })
    end
end)

function ChangeClothes (ped, components)
    local appearance = {}
    exports['illenium-appearance']:setPedComponents(ped,components)
    exports['illenium-appearance']:getPedAppearance(ped)
    TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
end

RNE('disnaker:client:OpenMenu', function()
    local InfoShop = lib.callback.await('disnaker:server:StatusShop', false)
    local SellDisable = false
    local BuyDisable = false
    if InfoShop.BuyShop == 'close' then
        BuyDisable = true
    end
    if InfoShop.SellShop == 'close' then
        SellDisable = true
    end
    local options = {
        {
            title = 'Ambil Pekerjaan',
            description = 'Ini adalah deskripsi tombol Ambil Pekerjaan',
            icon = 'list',
            event = 'disnaker:client:OpenMenuTakeJob',
        },
        {
            title = 'Beli Barang Disnaker',
            description = 'Ini adalah deskripsi tombol Beli Barang Disnaker',
            icon = 'cart-shopping',
            disabled = BuyDisable,
            onSelect = function()
                TSE('disnaker:server:SetSellState', 'open')
            end
        },
        {
            title = 'Jual Barang Disnaker',
            description = 'Ini adalah deskripsi tombol Jual Barang Disnaker',
            icon = 'money-bill',
            disabled = SellDisable,
            event = 'disnaker:client:SellDisnakerItem',
        }
    }
    local Player = QBCore.Functions.GetPlayerData()
    local ctz = Player.citizenid
    local bisa = false

    for i = 1, #Config.Admin do
        if ctz == Config.Admin[i] then
            bisa = true
            break
        end
    end
    if bisa then 
        table.insert(options, 
        {
            title = 'Rubah Pengaturan Disnaker',
            description = 'Hanya tersedia untuk admin / orang yang bisa',
            icon = 'cog',
            event = 'disnaker:client:SettingMenu',
        }
    )
    end

    lib.registerContext({
        id = 'some_menu',
        title = 'Some context menu',
        options = options
    })

    lib.showContext('some_menu')
end)

RNE('disnaker:client:SettingMenu', function()
    local StockOptions = {}
    local PriceOptions = {}
    local InfoShop = lib.callback.await('disnaker:server:StatusShop', false)
    local StopType = lib.callback.await('disnaker:server:GetTypeShop', false)
    for _, v in pairs(StopType) do
        local ItemType = v
        table.insert(StockOptions,
        {
            title = ItemType,
            icon = 'check',
            onSelect = function()
                local ItemData = lib.callback.await('disnaker:server:GetItemShop', false, ItemType)
                local ItemOptions = {}
                for _, v in pairs(ItemData) do
                    local ItemName = v.item
                    local Stock = v.stock
                    local itemNames = {}
                    for item, data in pairs(exports.ox_inventory:Items()) do
                        itemNames[item] = data.label
                    end
                    table.insert(ItemOptions, { label = itemNames[ItemName].." | Stok sekarang : "..Stock , value = ItemName })
                end
                local input = lib.inputDialog("Jual Barang Disnaker", {
                    {type = 'select', label = "Pilih Item : ", options = ItemOptions, required = true},
                    {type = 'number', label = "Perubahan", description = "Maksimal jumlah : ", icon = 'hashtag', min = 1, max = 1000},
                })
                if input then
                    TriggerServerEvent('disnaker:server:ChangeStock', input[1], input[2], ItemType)
                end
            end,
            arrow = true,
        })
    end
    for _, v in pairs(StopType) do
        local ItemType = v
        table.insert(PriceOptions,
        {
            title = ItemType,
            icon = 'check',
            onSelect = function()
                local ItemData = lib.callback.await('disnaker:server:GetItemShop', false, ItemType)
                local ItemOptions = {}
                for _, v in pairs(ItemData) do
                    local ItemName = v.item
                    local itemNames = {}
                    for item, data in pairs(exports.ox_inventory:Items()) do
                        itemNames[item] = data.label
                    end
                    table.insert(ItemOptions, { label = itemNames[ItemName] , value = ItemName })
                end
                local input = lib.inputDialog("Jual Barang Disnaker", {
                    {type = 'select', label = "Pilih Item : ", options = ItemOptions, required = true},
                })
                if input then
                    local selectedItem = nil
                    local selectedItemName = input[1]
                
                    -- Mencari data item yang sesuai dengan item yang dipilih
                    for _, v in pairs(ItemData) do
                        if v.item == selectedItemName then
                            selectedItem = v
                            break
                        end
                    end
                
                    if selectedItem then
                        local ItemOptions2 = {}
                
                        table.insert(ItemOptions2, { label = 'Harga Jual | Sekarang : ' .. selectedItem.sellprice, value = 'buy' })
                        table.insert(ItemOptions2, { label = 'Harga Beli | Sekarang : ' .. selectedItem.buyprice, value = 'sell' })
                
                        local input2 = lib.inputDialog("Jual Barang Disnaker", {
                            { type = 'select', label = "Tipe : ", options = ItemOptions2, required = true },
                            { type = 'number', label = "Perubahan", description = "Masukkan Harga Baru ", icon = 'hashtag' },
                        })
                
                        if input2 then
                            local selectedAction = input2[1]
                            local newPrice = tonumber(input2[2])
                            local item = selectedItem.item
                            TriggerServerEvent('disnaker:server:ChangePrice', item, newPrice, selectedAction, ItemType)
                        end
                    end
                end
            end,
            arrow = true,
        })
    end
    lib.registerContext({
        id = 'Stock_Menu',
        title = 'Rubah Stock Item',
        options = StockOptions,
        menu = 'Setting_Menu'
    })
    lib.registerContext({
        id = 'Set_Price',
        title = 'Rubah Harga Item',
        options = PriceOptions,
        menu = 'Setting_Menu'
    })
    lib.registerContext({
        id = 'Shop_Status',
        menu = 'Setting_Menu',
        title = 'Status Toko Disnaker',
        options = {
            {
                title = 'Toko Penjualan',
                description = 'Status : '.. InfoShop.SellShop, 
                icon = 'check',
                onSelect = function()
                    local input = lib.inputDialog("Toko Penjualan Barang Disnaker", {
                        {type = 'select', label = "Status Toko : ", options = {
                            { label = 'Buka' , value = 'open' },
                            { label = 'Tutup' , value = 'close' }
                        }, required = true},
                    })
                    if input then
                        TriggerServerEvent('disnaker:server:SetShopStatus', 'Sell', input[1])
                    end
                end,
                arrow = true,
            },
            {
                title = 'Toko Pembelian',
                icon = 'check',
                description = 'Status : '.. InfoShop.BuyShop, 
                onSelect = function()
                    local input = lib.inputDialog("Toko Pembelian Barang Disnaker", {
                        {type = 'select', label = "Status Toko : ", options = {
                            { label = 'Buka' , value = 'open' },
                            { label = 'Tutup' , value = 'close' }
                        }, required = true},
                    })
                    if input then
                        TriggerServerEvent('disnaker:server:SetShopStatus', 'Buy', input[1])
                    end
                end,
                arrow = true,
            }
        }
    })
    lib.registerContext({
        id = 'Setting_Menu',
        title = 'Ambil Pekerjaan',
        options = {
            {
                title = 'Stok barang',
                description = 'Tambah / Kurangi stok barang',
                icon = 'cog',
                menu = 'Stock_Menu'
            },
            {
                title = 'Status Toko',
                description = 'Buka / Tutup toko disnaker',
                icon = 'cog',
                menu = 'Shop_Status'
            },
            {
                title = 'Harga',
                description = 'Ubah Harga Barang',
                icon = 'cog',
                menu = 'Set_Price',
            },
            {
                title = 'Setting',
                description = 'Tambah / Kurangi List Barang',
                icon = 'cog',
                event = 'disnaker:client:SettingListItem',
            },
        }
    })

    lib.showContext('Setting_Menu')
end)

RNE('disnaker:client:SettingListItem', function()
    lib.registerContext({
        id = 'Create_List',
        title = 'Ambil Pekerjaan',
        options = 
    })
    lib.registerContext({
        id = 'Setting_Menu',
        title = 'Ambil Pekerjaan',
        options = {
            {
                title = 'Tambah Jenis Item',
                description = 'Tambah / Kurangi stok barang',
                icon = 'cog',
                menu = 'Create_List'
            },
            {
                title = 'Tambah Item',
                description = 'Buka / Tutup toko disnaker',
                icon = 'cog',
                menu = 'Create_Item'
            },
            {
                title = 'Hapus Jenis Item',
                description = 'Ubah Harga Barang',
                icon = 'cog',
                menu = 'Delete_List',
            },
            {
                title = 'Hapus Item',
                description = 'Tambah / Kurangi List Barang',
                icon = 'cog',
                menu = 'Delete_List',
            },
        }
    })

    lib.showContext('Setting_Menu')
end)

RNE('disnaker:client:SellDisnakerItem', function()
    local data = lib.callback.await('disnaker:server:GetTypeShop', false)
    local options = {}
    for _, v in pairs(data) do
        local ItemType = v
        table.insert(options,
        {
            title = ItemType,
            icon = 'check',
            event = 'disnaker:client:SellDisnakerItem2',
            arrow = true,
            args = {
                Type = ItemType
            }
        })
    end

    lib.registerContext({
        id = 'disnaker_menu',
        title = 'Ambil Pekerjaan',
        options = options
    })

    lib.showContext('disnaker_menu')
end)

RNE('disnaker:client:SellDisnakerItem2', function(args)
    local options = {}
    local Type = args.Type
    local data = lib.callback.await('disnaker:server:GetItemShop', false, Type)
    for _,v in pairs(data) do
        local itemNames = {}
        local ItemType = v.item
        for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
        end
        local ItemCount = exports.ox_inventory:GetItemCount(ItemType)
        local disable = true
        if ItemCount > 0 then
            disable = false
        end
        table.insert(options,
        {
            title = itemNames[ItemType],
            description = 'Harga : '..v.sellprice.." | Total barang di kantong : "..ItemCount,
            icon = 'list',
            disabled = disable,
            onSelect = function()
                local input = lib.inputDialog("Jual Barang Disnaker", {
                    {type = 'number', label = "Harga Satuan : "..v.sellprice, description = "Maksimal jual : "..tonumber(ItemCount), icon = 'hashtag', min = 1, max = ItemCount},
                })
                if input then
                    TotalPrice = v.sellprice * input[1]
                    TriggerServerEvent('disnaker:server:SellItem', TotalPrice, ItemType, input[1], Type)
                end
            end,
            arrow = true,
            args = {
                Type = ItemType,
                Stock = v.stock
            },
        })
    end

    lib.registerContext({
        id = 'disnaker_menu2',
        title = 'Ambil Pekerjaan',
        options = options,
        onBack = function()
            TriggerEvent('disnaker:client:SellDisnakerItem')
        end
    })
    lib.showContext('disnaker_menu2')
end)

RNE('disnaker:client:BuyDisnakerItem', function()
    local data = lib.callback.await('disnaker:server:GetTypeShop', false)
    local options = {}
    for _, v in pairs(data) do
        local ItemType = v
        table.insert(options,
        {
            title = ItemType,
            icon = 'check',
            event = 'disnaker:client:BuyDisnakerItem2',
            arrow = true,
            args = {
                Type = ItemType
            }
        })
    end

    lib.registerContext({
        id = 'disnaker_menu',
        title = 'Ambil Pekerjaan',
        options = options
    })

    lib.showContext('disnaker_menu')
end)

RNE('disnaker:client:BuyDisnakerItem2', function(args)
    local options = {}
    local Type = args.Type
    local data = lib.callback.await('disnaker:server:GetItemShop', false, Type)
    for _,v in pairs(data) do
        local itemNames = {}
        local ItemType = v.item
        for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
        end
        local Money = exports.ox_inventory:GetItemCount('money')
        local disable = true
        if v.stock > 0 then
            disable = false
        end
        table.insert(options,
        {
            title = itemNames[ItemType],
            description = 'Harga : '..v.buyprice.." | Stok : "..v.stock,
            icon = 'list',
            disabled = disable,
            onSelect = function()
                local MaxBuy = Money / v.buyprice
                if MaxBuy > v.stock then
                    MaxBuy = v.stock
                end
                local input = lib.inputDialog("Jual Barang Disnaker", {
                    {type = 'number', label = "Harga Satuan : "..v.buyprice, description = "Maksimal beli : "..math.floor(MaxBuy), icon = 'hashtag', min = 1, max = MaxBuy},
                })
                TriggerServerEvent('disnaker:server:SetSellState', 'close')
                if input then
                    TotalPrice = v.buyprice * input[1]
                    TriggerServerEvent('disnaker:server:BuyItem', TotalPrice, ItemType, input[1], Type)
                end
            end,
            arrow = true,
            args = {
                Type = ItemType,
                Stock = v.stock
            },
        })
    end

    lib.registerContext({
        id = 'disnaker_menu2',
        title = 'Ambil Pekerjaan',
        options = options,
        onBack = function()
            TriggerEvent('disnaker:client:SellDisnakerItem')
        end
    })
    lib.showContext('disnaker_menu2')
end)

RNE('disnaker:client:OpenMenuTakeJob', function()
    local options = {}
    for k,v in pairs(Config.Kerjaan) do
        local PlayerJob = QBCore.Functions.GetPlayerData().job.name
        local disabled = false
        local job = k
        local label = v.Label
        if PlayerJob ~= job then
            disabled = false
        else
            disabled = true
        end
        table.insert(options,
        {
            title = label,
            description = 'Open a menu from the event and send event data',
            icon = 'check',
            event = 'disnaker:client:ChangeClothes',
            disabled = disabled,
            arrow = true,
            args = {
              job = job
            }
        }
    )
    end

    lib.registerContext({
        id = 'disnaker_menu',
        title = 'Ambil Pekerjaan',
        options = options,
        
    })
    lib.showContext('disnaker_menu')
end)

RNE('disnaker:client:ChangeClothes', function(args)
    local job = args.job
    if lib.progressBar({
        duration = 5000,
        label = 'Memakai Baju Kerja',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
        anim = {
            dict = 'clothingtie',
            clip = 'try_tie_neutral_c'
        },
        prop = {},
    }) 
    then
        local gender = exports['illenium-appearance']:getPedModel(ped)
        local components = {}
        if gender == cowok then
            components = Config.Kerjaan[job].Baju.Cowok
            ChangeClothes(ped, components)
        elseif gender == cewek then
            components = Config.Kerjaan[job].Baju.Cewek
            ChangeClothes(ped, components)
        end
        TSE('disnaker:server:SetJob', job)
    else
    end
end)

Config = {}

Config.TempatTinju = {
    ['Pantai'] = {
        lokasi = vector4(-323.74, -941.61, 31.08, 252.9),
        ped = "a_f_m_tourist_01",
        spawn1 = vector4(-1272.76, -1534.16, 5.15, 21.68),
        spawn2 = vector4(-1276.73, -1527.72, 5.15, 200.83),
        h2 = 200.83,
        h1 = 21.68,
        harga = 5000,
        
    },
    -- ['Paleto'] = {
    --     lokasi = vector4(-711.51, -1289.75, 5.1, 57.91),
    --     ped = "a_f_m_tourist_01",
    --     spawn = vector4(-716.31, -1289.24, 5.0, 137.3),
    --     harga = 5000,
    --     mobil = {
    --         'akuma',
    --         'sultanrs',
    --     },
    -- },
}
    SetPedComponentVariation(ped, 1, 0, 0, 0) -- masker
    SetPedComponentVariation(ped, 11, 38, 0, 0) -- jacket
    SetPedComponentVariation(ped, 3, 178, 0, 0) -- tangan
    SetPedComponentVariation(ped, 4, 40, 0, 0) -- celana
    SetPedComponentVariation(ped, 5, 0, 0, 0) -- tas
    SetPedComponentVariation(ped, 6, 129, 0, 0) -- sepatu
    SetPedComponentVariation(ped, 7, 0, 0, 0) -- aksesoris
    SetPedComponentVariation(ped, 8, 15, 0, 0) -- shirt
Config.Kerjaan = {
    ['tambang'] = {
        Label = 'Pekerjaan Tambang',
        Baju = {
            Cowok = {
                [1] = {  component_id = 1, drawable = 0, texture = 0 },
                [2] = {  component_id = 11, drawable = 22, texture = 0 },
                [3] = {  component_id = 3, drawable = 155, texture = 0 },
                [4] = {  component_id = 4, drawable = 40, texture = 0 },
                [5] = {  component_id = 5, drawable = 4, texture = 0 },
                [6] = {  component_id = 6, drawable = 129, texture = 0 },
                [7] = {  component_id = 7, drawable = 0, texture = 0 },
                [8] = {  component_id = 8, drawable = 15, texture = 0 }
            },
            Cewek = {
                [1] = {  component_id = 1, drawable = 0, texture = 0 },
                [2] = {  component_id = 11, drawable = 38, texture = 0 },
                [3] = {  component_id = 3, drawable = 178, texture = 0 },
                [4] = {  component_id = 4, drawable = 40, texture = 0 },
                [5] = {  component_id = 5, drawable = 0, texture = 0 },
                [6] = {  component_id = 6, drawable = 129, texture = 0 },
                [7] = {  component_id = 7, drawable = 0, texture = 0 },
                [8] = {  component_id = 8, drawable = 15, texture = 0 }
            }
        }
    },
    -- ['bus'] = {
    --     Label = 'Pekerjaan Bus',
    -- },
    -- ['penjahit'] = {
    --     Label = 'Pekerjaan Penjahit',
    -- },
    -- ['kayu'] = {
    --     Label = 'Pekerjaan Kayu',
    -- },
    -- ['ayam'] = {
    --     Label = 'Pekerjaan Ayam',
    -- },
    -- ['gojek'] = {
    --     Label = 'Pekerjaan Gojek',
    -- },
    -- ['ikan'] = {
    --     Label = 'Pekerjaan Ikan',
    -- },
    -- ['garbage'] = {
    --     Label = 'Pekerjaan Sampah',
    -- }
}

-- Config.Item = {
--     ['tambang'] = {
--         [1] = {
--             item = 'iron_bar',
--             label = 'Besi',
--             price = 200
--         },
--         [2] = {
--             item = 'chopper_bar',
--             label = 'Tembaga',
--             price = 200
--         },
--         [3] = {
--             item = 'gold_bar',
--             label = 'Emas',
--             price = 325
--         },
--         [4] = {
--             item = 'diamond',
--             label = 'Berlian',
--             price = 325
--         }
--     },
--     ['recycle'] = {
--         --Recycle
--         [1] = {
--             item = 'aluminum',
--             label = 'Alumunium',
--             price = 100
--         },
--         [2] = {
--             item = 'botolbekas',
--             label = 'Botol Bekas',
--             price = 100
--         },
--         [3] = {
--             item = 'bateraibekas',
--             label = 'Baterai Bekas',
--             price = 100
--         },
--         [4] = {
--             item = 'plastic',
--             label = 'Plastik',
--             price = 100
--         },
--         [5] = {
--             item = 'glass',
--             label = 'Kaca',
--             price = 100
--         }
--     },
--     ['kayu'] = {
--         --TUKANG KAYU
--         [1] = {
--             item = 'tree_bark',
--             label = 'Kulit Kayu',
--             price = 85
--         },
--         [2] = {
--             item = 'paketkayu',
--             label = 'Paket Kayu',
--             price = 275
--         }
--     },
--     ['minyak'] = {
--         [1] = {
--             item = 'gasoline',
--             label = 'Gasoline',
--             price = 80
--         },
--         [2] = {
--             item = 'minyakgoreng',
--             label = 'Minyak Goreng',
--             price = 90
--         },
--         [3] = {
--             item = 'gas',
--             label = 'Tabung Gas',
--             price = 325
--         }
--     },
--     ['jahit'] = {
--         --PENJAHIT
--         [1] = {
--             item = 'woll',
--             label = 'Benang',
--             price = 50
--         },
--         [2] = {
--             item = 'fabric',
--             label = 'Kain',
--             price = 25
--         },
--         [3] = {
--             item = 'clothes',
--             label = 'Baju',
--             price = 250
--         }
--     },
--     ['ikan'] = {
--         --NELAYAN
--         [1] = {
--             item = 'ikan',
--             label = 'Ikan Mentah',
--             price = 80
--         },
--         [2] = {
--             item = 'paketikan',
--             label = 'Paket Ikan',
--             price = 150
--         }
--     },
--     ['ayam'] = {
--         --TUKANG AYAM
--         [1] = {
--             item = 'ayam',
--             label = 'Ayam Hidup',
--             price = 80
--         },
--         [2] = {
--             item = 'paketayam',
--             label = 'Paket Ayam',
--             price = 150
--         }
--         --PETANI
--     }
-- }

Config.Admin = {
    'OQF71500', 
    'OVQ06339', --uncle
    'GMT03888', --mang obe
    'OHQ85556', 
}

function Notify(text, type)
    local src = source
    if src ~= nil then
        TriggerClientEvent('QBCore:Notify',src, text, type, 5000)
    else
        TriggerEvent('QBCore:Notify', text, type, 5000)
    end
end
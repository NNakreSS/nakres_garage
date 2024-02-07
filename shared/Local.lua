Text = {
    -- Türkçe (Turkish)
    ['Tr'] = {
        error = {
            not_own = "Bu aracın sahibi değilsin",
            garage_full = "Tamamen dolu, bu garajda boş yer yok",
            not_own_players = "Bu araba bir oyuncuya ait değil",
            seats_not_free = "Araç boş değil",
            not_police = "Bunun için polis olmalısın",
            not_garage_type = "Bu araç bu garaja uygun değil",
            not_money = 'Yeterli paran yok, banka veya nakit miktarını kontrol et',
            not_clear_area = 'Araç çıkış alanı müsait değil',
            garage_not_vehicle = 'Bu garajda bir aracın yok',
            not_create_garage = 'Önce bir garaj oluşturmalısın',
            already_exist_garage = 'Bu garaj indexi zaten mevcut',
            not_garage_index = 'Garaj indexi belirtmelisin "/garage motelgarage"'
        },
        success = {
            parked_vehicle = "Araç parkedildi",
            impound = "Araç çekildi",
            add_prev_coord = 'Bir önizleme kordinatı eklendi',
            set_npc_model = 'Npc tipi: %s ve npc yönü %d olarak ayarlandı',
            created_garage = "Garaj başarıyla oluşturuldu"
        },
        ui = {
            limit = 'LİMİT',
            total = 'TOPLAM',
            spawn = 'Çıkart',
            model = 'Model',
            garage = 'Garaj',
            impounds = 'Çekilmişler',
            admin = {
                header = 'Garaj Oluştur',
                info = "Graj tipi job olarak seçildiyse meslek ve meslek grade (job type) belirtmek zorundasınız, preview coord boş bırakılırsa varsayılan olarak spawn coord preview coord olarak kullanılır",
                garageName = 'Garaj Label',
                garageType = 'Garaj Tipi',
                vehicleType = "Araç tipi",
                garageLimit = 'Garaj limiti',
                job = 'Meslek',
                jobType = 'Rütbe',
                npcCoord = 'Npc kordinatı',
                spawnCoord = 'Çıkarma kordinatı',
                enterCoord = 'Garaj kordinatı',
                previewCoord = 'Önizleme kordinatı',
                blip = 'Blip',
                submit = 'Kaydet',
                unlimited = "Limitsiz"
            }
        }
    },

    -- İngilizce (English)
    ['En'] = {
        error = {
            not_own = "You don't own this vehicle",
            garage_full = "Full, no space available in this garage",
            not_own_players = "This vehicle does not belong to a player",
            seats_not_free = "The vehicle is not empty",
            not_police = "You must be a police officer for this",
            not_garage_type = "This vehicle is not suitable for this garage",
            not_money = 'You do not have enough money, check your bank or cash amount',
            not_clear_area = 'Vehicle spawn area is not clear',
            garage_not_vehicle = 'You do not have a vehicle in this garage',
            not_create_garage = 'You must create a garage first',
            already_exist_garage = 'This garage index already exists',
            not_garage_index = 'You must specify the garage index "/garage motelgarage"'
        },
        success = {
            parked_vehicle = "Vehicle parked",
            impound = "Vehicle impounded",
            add_prev_coord = 'Added a preview coordinate',
            set_npc_model = 'Npc type set as: %s and npc heading as %d',
            created_garage = "Garage created successfully"
        },
        ui = {
            limit = 'LIMIT',
            total = 'TOTAL',
            spawn = 'Spawn',
            model = 'Model',
            garage = 'Garage',
            impounds = 'Impounds',
            admin = {
                header = 'Create Garage',
                info = "If the garage type is selected as a job, you must specify the job and job grade (job type); if the preview coord is left blank, it will be used as the default spawn coord preview coord",
                garageName = 'Garage Label',
                garageType = 'Garage Type',
                vehicleType = "Vehicle type",
                garageLimit = 'Garage limit',
                job = 'Job',
                jobType = 'Rank',
                npcCoord = 'Npc coordinates',
                spawnCoord = 'Spawn coordinates',
                enterCoord = 'Garage coordinates',
                previewCoord = 'Preview coordinates',
                blip = 'Blip',
                submit = 'Save',
                unlimited = "Unlimited"
            }
        }
    },

    -- Almanca (German)
    ['De'] = {
        error = {
            not_own = "Du besitzt dieses Fahrzeug nicht",
            garage_full = "Voll, kein Platz in dieser Garage verfügbar",
            not_own_players = "Dieses Fahrzeug gehört keinem Spieler",
            seats_not_free = "Das Fahrzeug ist nicht leer",
            not_police = "Du musst Polizist sein, um dies zu tun",
            not_garage_type = "Dieses Fahrzeug ist nicht für diese Garage geeignet",
            not_money = 'Du hast nicht genug Geld, überprüfe deinen Bank- oder Bargeldbetrag',
            not_clear_area = 'Fahrzeug-Spawnbereich ist nicht frei',
            garage_not_vehicle = 'Du hast kein Fahrzeug in dieser Garage',
            not_create_garage = 'Du musst zuerst eine Garage erstellen',
            already_exist_garage = 'Dieser Garagen-Index existiert bereits',
            not_garage_index = 'Du musst den Garagen-Index angeben "/garage motelgarage"'
        },
        success = {
            parked_vehicle = "Fahrzeug geparkt",
            impound = "Fahrzeug sichergestellt",
            add_prev_coord = 'Eine Vorschau-Koordinate wurde hinzugefügt',
            set_npc_model = 'Npc-Typ festgelegt als: %s und Npc-Richtung als %d',
            created_garage = "Garage erfolgreich erstellt"
        },
        ui = {
            limit = 'LIMIT',
            total = 'GESAMT',
            spawn = 'Spawnen',
            model = 'Modell',
            garage = 'Garage',
            impounds = 'Sicherstellungen',
            admin = {
                header = 'Garage erstellen',
                info = "Wenn der Garagentyp als Job ausgewählt ist, müssen Sie den Job und den Job-Grad (Job-Typ) angeben; Wenn die Vorschau-Koordinate leer gelassen wird, wird sie als Standard-Spawn-Koordinate Vorschau-Koordinate verwendet",
                garageName = 'Garagen-Label',
                garageType = 'Garagentyp',
                vehicleType = "Fahrzeugtyp",
                garageLimit = 'Garagenlimit',
                job = 'Job',
                jobType = 'Rang',
                npcCoord = 'Npc-Koordinaten',
                spawnCoord = 'Spawn-Koordinaten',
                enterCoord = 'Garagen-Koordinaten',
                previewCoord = 'Vorschau-Koordinaten',
                blip = 'Blip',
                submit = 'Speichern',
                unlimited = "Unbegrenzt"
            }
        }
    }
}

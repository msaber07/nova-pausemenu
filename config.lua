Config = {}

-- Language Option: 'tr' or 'en'
Config.Locale = 'en'

-- Genel Sunucu Bilgileri
Config.Discord  = 'discord.gg/yourserver'
Config.SubLabel = 'v1.1.0'

-- Sunucu duyurusu (Sunucu sekmesi)
Config.Announce = {
    tr = 'Hafta sonu 2x maaş etkinliği aktif! Kurallara uymayan oyuncular kalıcı olarak uzaklaştırılır.',
    en = 'Weekend 2x salary event is active! Players who violate the rules will be permanently banned.'
}

-- Kurallar listesi
Config.Rules = {
    tr = {
        'RDM / VDM yasaktır.',
        'Power gaming ve metagaming yasaktır.',
        'OOC sohbeti minimumda tutun, rol içi (IC) kalın.',
        'Yetkililere saygılı olun, şikayetlerinizi Discord üzerinden iletin.',
        'FailRP yapmayın; karakterinizi gerçekçi ve tutarlı oynayın.',
    },
    en = {
        'RDM / VDM is strictly prohibited.',
        'Powergaming and Metagaming are forbidden.',
        'Keep OOC chat to a minimum, always stay In-Character (IC).',
        'Respect staff members and submit appeals/reports via Discord.',
        'Avoid FailRP; play your character realistically and consistently.',
    }
}

-- List of key assignments (for display in the information panel)
Config.Keys = {
    tr = {
        { a = 'Envanter',          k = 'TAB' },
        { a = 'Etkileşim Menüsü',  k = 'M'   },
        { a = 'Telefon',           k = 'F1'  },
        { a = 'Hedefleme',         k = 'ALT' },
        { a = 'Ev Anahtarları',    k = 'F6'  },
        { a = 'HUD Menüsü',        k = 'F7'  },
        { a = 'El Kaldır',         k = 'X'   },
        { a = 'Motoru Aç/Kapat',   k = 'G'   },
        { a = 'Kelepçe/Teslim',    k = 'Y'   },
        { a = 'Araç Kilidi',       k = 'U'   },
    },
    en = {
        { a = 'Inventory',         k = 'TAB' },
        { a = 'Interaction Menu',  k = 'M'   },
        { a = 'Phone',             k = 'F1'  },
        { a = 'Targeting',         k = 'ALT' },
        { a = 'House Keys',        k = 'F6'  },
        { a = 'HUD Menu',          k = 'F7'  },
        { a = 'Raise Hands',       k = 'X'   },
        { a = 'Toggle Engine',     k = 'G'   },
        { a = 'Cuff/Surrender',    k = 'Y'   },
        { a = 'Vehicle Lock',      k = 'U'   },
    }
}

-- ── Character cinema (camera focused on pad when menu opened) ──
Config.ShowCharacter = true          -- Should the camera focus on the character when the menu is opened?
Config.CamDistance   = 2.2           -- camera distance to pad (meters)
Config.CamHeight     = 0.55          -- camera height (pad from bottom of foot)
Config.CamLookZ      = 0.45          -- viewing point height (chest/face level)
Config.CamFov        = 38.0          -- angle of view (field of view)
-- Optional pose scenario (null = no lock-on, current pose). Ex:
-- 'WORLD_HUMAN_STAND_IMPATIENT', 'WORLD_HUMAN_SMOKING', 'WORLD_HUMAN_AA_COFFEE'
Config.CharacterScenario = ''

-- Exit Button
Config.DisconnectReason = {
    tr = 'Pause menüden çıkış yaptınız.',
    en = 'You disconnected via the pause menu.'
}

-- ── TRANSLATION TABLE (UI / NUI Elements) ──
Config.Locales = {
    tr = {
        -- Navigasyon / Sekmeler
        nav_info = 'Bilgi',
        nav_info_sub = 'Karakter & cüzdan',
        nav_players = 'Oyuncular',
        nav_players_sub = 'Çevrimiçi liste',
        nav_server = 'Sunucu',
        nav_server_sub = 'Bilgi & kurallar',
        nav_settings = 'Ayarlar',
        nav_settings_sub = 'Oyun ayarları (ESC)',
        nav_map = 'Harita',
        nav_map_sub = 'Dünya haritasını aç',
        nav_quit = 'Ayrıl',
        nav_quit_sub = 'Sunucudan çık',
        
        -- Sol Alt Kartlar / Bilgiler
        lbl_player_id = 'Oyuncu ID',
        lbl_name = 'İSİM',
        lbl_job = 'MESLEK',
        lbl_cash = 'NAKİT',
        lbl_bank = 'BANKA',
        btn_resume = 'Oyuna Dön',
        
        -- Karakter Bilgisi Sekmesi
        title_char_info = 'Karakter Bilgisi',
        lbl_citizenid = 'Vatandaşlık No',
        lbl_phone = 'Telefon',
        lbl_gang = 'Çete',
        lbl_session = 'Oturum',
        lbl_unemployed = 'İşsiz',
        lbl_none = 'Yok',
        
        -- Oyuncular Sekmesi
        title_online_players = 'Çevrimiçi Oyuncular',
        placeholder_search = 'Oyuncu ara...',
        
        -- Sunucu Sekmesi
        title_server_info = 'Sunucu Bilgisi',
        lbl_stat_players = 'Oyuncu',
        lbl_stat_uptime = 'Uptime',
        lbl_stat_community = 'Topluluk',
        title_announcement = 'Duyuru',
        title_rules = 'Kurallar',
        title_keys = 'Tuş Atamaları',
        
        -- Confirmation Modal (Disconnect Confirmation)
        confirm_title = 'Ayrılmak İstiyor musunuz?',
        confirm_desc = 'Sunucudan çıkış yapmak üzeresiniz. Emin misiniz?',
        confirm_yes = 'Evet, Ayrıl',
        confirm_no = 'Hayır, Vazgeç',
        
        -- Other
        msg_offline = 'Çevrimdışı',
        uptime_fmt = '%dsa %ddk',
        uptime_fmt_min = '%ddk',
    },
    en = {
        -- Navigation / Tabs
        nav_info = 'Information',
        nav_info_sub = 'Character & wallet',
        nav_players = 'Players',
        nav_players_sub = 'Online list',
        nav_server = 'Server',
        nav_server_sub = 'Info & rules',
        nav_settings = 'Settings',
        nav_settings_sub = 'Game settings (ESC)',
        nav_map = 'Map',
        nav_map_sub = 'Open world map',
        nav_quit = 'Disconnect',
        nav_quit_sub = 'Leave server',
        
        -- Left Bottom Cards / Stats
        lbl_player_id = 'Player ID',
        lbl_name = 'NAME',
        lbl_job = 'JOB',
        lbl_cash = 'CASH',
        lbl_bank = 'BANK',
        btn_resume = 'Resume Game',
        
        -- Character Info Tab
        title_char_info = 'Character Details',
        lbl_citizenid = 'Citizen ID',
        lbl_phone = 'Phone Number',
        lbl_gang = 'Gang',
        lbl_session = 'Session',
        lbl_unemployed = 'Unemployed',
        lbl_none = 'None',
        
        -- Players Tab
        title_online_players = 'Online Players',
        placeholder_search = 'Search players...',
        
        -- Server Tab
        title_server_info = 'Server Information',
        lbl_stat_players = 'Players',
        lbl_stat_uptime = 'Uptime',
        lbl_stat_community = 'Community',
        title_announcement = 'Announcement',
        title_rules = 'Rules',
        title_keys = 'Keybinds',
        
        -- Confirmation Modal (Disconnect Confirmation)
        confirm_title = 'Are you sure?',
        confirm_desc = 'You are about to disconnect from the server. Do you want to proceed?',
        confirm_yes = 'Yes, Disconnect',
        confirm_no = 'No, Cancel',
        
        -- Miscellaneous
        msg_offline = 'Offline',
        uptime_fmt = '%dh %dm',
        uptime_fmt_min = '%dm',
    }
}

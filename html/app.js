/* Nova Pause Menu — UI logic
 * Browser preview: Starts open with localized mock data.
 * FiveM: Handles window 'message' (open/close/data) + fetch callbacks.
 */
const IN_GAME = typeof window.GetParentResourceName === 'function';
const RES = IN_GAME ? window.GetParentResourceName() : 'nova-pausemenu';
const $  = s => document.querySelector(s);
const $$ = s => document.querySelectorAll(s);

function esc(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// Browser Dil Algılama
const systemLang = navigator.language || navigator.userLanguage;
const defaultLocale = systemLang.startsWith('tr') ? 'tr' : 'en';

const MOCK_LOCALES = {
  tr: {
    nav_info: 'Bilgi', nav_info_sub: 'Karakter & cüzdan',
    nav_players: 'Oyuncular', nav_players_sub: 'Çevrimiçi liste',
    nav_server: 'Sunucu', nav_server_sub: 'Bilgi & kurallar',
    nav_settings: 'Ayarlar', nav_settings_sub: 'Oyun ayarları (ESC)',
    nav_map: 'Harita', nav_map_sub: 'Dünya haritasını aç',
    nav_quit: 'Ayrıl', nav_quit_sub: 'Sunucudan çık',
    lbl_player_id: 'Oyuncu ID', lbl_name: 'İSİM', lbl_job: 'MESLEK', lbl_cash: 'NAKİT', lbl_bank: 'BANKA',
    btn_resume: 'Oyuna Dön', title_char_info: 'Karakter Bilgisi',
    lbl_citizenid: 'Vatandaşlık No', lbl_phone: 'Telefon', lbl_gang: 'Çete', lbl_session: 'Oturum',
    lbl_unemployed: 'İşsiz', lbl_none: 'Yok', title_online_players: 'Çevrimiçi Oyuncular',
    placeholder_search: 'Oyuncu ara...', title_server_info: 'Sunucu Bilgisi',
    lbl_stat_players: 'Oyuncu', lbl_stat_uptime: 'Uptime', lbl_stat_community: 'Topluluk',
    title_announcement: 'Duyuru', title_rules: 'Kurallar', title_keys: 'Tuş Atamaları'
  },
  en: {
    nav_info: 'Information', nav_info_sub: 'Character & wallet',
    nav_players: 'Players', nav_players_sub: 'Online list',
    nav_server: 'Server', nav_server_sub: 'Info & rules',
    nav_settings: 'Settings', nav_settings_sub: 'Game settings (ESC)',
    nav_map: 'Map', nav_map_sub: 'Open world map',
    nav_quit: 'Disconnect', nav_quit_sub: 'Leave server',
    lbl_player_id: 'Player ID', lbl_name: 'NAME', lbl_job: 'JOB', lbl_cash: 'CASH', lbl_bank: 'BANK',
    btn_resume: 'Resume Game', title_char_info: 'Character Details',
    lbl_citizenid: 'Citizen ID', lbl_phone: 'Phone Number', lbl_gang: 'Gang', lbl_session: 'Session',
    lbl_unemployed: 'Unemployed', lbl_none: 'None', title_online_players: 'Online Players',
    placeholder_search: 'Search players...', title_server_info: 'Server Information',
    lbl_stat_players: 'Players', lbl_stat_uptime: 'Uptime', lbl_stat_community: 'Community',
    title_announcement: 'Announcement', title_rules: 'Rules', title_keys: 'Keybinds'
  }
};

const MOCK = {
  tr: {
    server: { 
      name: 'NOVA ROLEPLAY', sub: 'v1.0.0', players: 12, max: 64, uptime: '2sa 45dk',
      discord: 'discord.gg/yourserver',
      announce: 'Hafta sonu 2x maaş etkinliği aktif! Kurallara uymayan oyuncular kalıcı olarak uzaklaştırılır.',
      rules: ['RDM / VDM yasaktır.', 'Power gaming ve metagaming yasaktır.', 'OOC sohbeti minimumda tutun, rol içi (IC) kalın.', 'Yetkililere saygılı olun.', 'FailRP yapmayın.'] 
    },
    player: { 
      name: 'Murat Yılmaz', id: 14, job: 'Emlakçı', ping: 12, cid: 'UKO55374',
      phone: '555-0182', gang: 'Yok', cash: '$1.450', bank: '$235.800', playtime: '42dk' 
    },
    players: [
      { id: 4, name: 'Can Öztürk', ping: 18 }, { id: 14, name: 'Murat Yılmaz', ping: 12 },
      { id: 25, name: 'Elif Kaya', ping: 32 }, { id: 33, name: 'Zeynep Ak', ping: 24 },
      { id: 56, name: 'Ahmet Demir', ping: 45 }
    ],
    keys: [
      { a: 'Envanter', k: 'TAB' }, { a: 'Etkileşim Menüsü', k: 'M' }, { a: 'Telefon', k: 'F1' },
      { a: 'Hedefleme', k: 'ALT' }, { a: 'Ev Anahtarları', k: 'F6' }, { a: 'HUD Menüsü', k: 'F7' },
      { a: 'El Kaldır', k: 'X' }, { a: 'Motoru Aç/Kapat', k: 'G' }
    ],
    locale: MOCK_LOCALES.tr
  },
  en: {
    server: { 
      name: 'NOVA ROLEPLAY', sub: 'v1.0.0', players: 12, max: 64, uptime: '2h 45m',
      discord: 'discord.gg/yourserver',
      announce: 'Weekend 2x salary event is active! Players who violate the rules will be permanently banned.',
      rules: ['RDM / VDM is strictly prohibited.', 'Powergaming and Metagaming are forbidden.', 'Keep OOC chat to a minimum, stay In-Character.', 'Respect staff members.', 'Avoid FailRP.'] 
    },
    player: { 
      name: 'John Doe', id: 14, job: 'Real Estate Agent', ping: 12, cid: 'UKO55374',
      phone: '555-0182', gang: 'None', cash: '$1,450', bank: '$235,800', playtime: '42m' 
    },
    players: [
      { id: 4, name: 'John Doe', ping: 12 }, { id: 14, name: 'Jane Smith', ping: 18 },
      { id: 25, name: 'Alice Watson', ping: 32 }, { id: 33, name: 'Bob Harris', ping: 24 },
      { id: 56, name: 'Charlie Miller', ping: 45 }
    ],
    keys: [
      { a: 'Inventory', k: 'TAB' }, { a: 'Interaction Menu', k: 'M' }, { a: 'Phone', k: 'F1' },
      { a: 'Targeting', k: 'ALT' }, { a: 'House Keys', k: 'F6' }, { a: 'HUD Menu', k: 'F7' },
      { a: 'Raise Hands', k: 'X' }, { a: 'Toggle Engine', k: 'G' }
    ],
    locale: MOCK_LOCALES.en
  }
};

let DATA = MOCK[defaultLocale];

function applyTranslations() {
  const t = DATA.locale || MOCK_LOCALES[defaultLocale];
  
  // Navigasyon
  $('#navInfo').textContent = t.nav_info;
  $('#navInfoSub').textContent = t.nav_info_sub;
  $('#navPlayers').textContent = t.nav_players;
  $('#navPlayersSub').textContent = t.nav_players_sub;
  $('#navServer').textContent = t.nav_server;
  $('#navServerSub').textContent = t.nav_server_sub;
  $('#navSettings').textContent = t.nav_settings;
  $('#navSettingsSub').textContent = t.nav_settings_sub;
  $('#navMap').textContent = t.nav_map;
  $('#navMapSub').textContent = t.nav_map_sub;
  $('#navQuit').textContent = t.nav_quit;
  $('#navQuitSub').textContent = t.nav_quit_sub;
  
  // Sol Kartlar
  $('#lblPlayerId').textContent = t.lbl_player_id + ':';
  $('#lblCardName').textContent = t.lbl_name;
  $('#lblCardJob').textContent = t.lbl_job;
  $('#lblCardCash').textContent = t.lbl_cash;
  $('#lblCardBank').textContent = t.lbl_bank;
  $('#btnResumeText').textContent = t.btn_resume;
  
  // Bilgi Sekmesi
  $('#titleCharInfo').textContent = t.title_char_info;
  $('#lblCid').textContent = t.lbl_citizenid;
  $('#lblPhone').textContent = t.lbl_phone;
  $('#lblJob').textContent = t.lbl_job;
  $('#lblGang').textContent = t.lbl_gang;
  $('#lblStatCash').textContent = t.lbl_cash;
  $('#lblStatBank').textContent = t.lbl_bank;
  $('#lblStatSession').textContent = t.lbl_session;
  $('#titleKeys').textContent = t.title_keys;
  
  // Oyuncular Sekmesi
  $('#titleOnlinePlayers').textContent = t.title_online_players;
  $('#plSearch').placeholder = t.placeholder_search;
  
  // Sunucu Sekmesi
  $('#titleServerInfo').textContent = t.title_server_info;
  $('#lblServerStatPlayers').textContent = t.lbl_stat_players;
  $('#lblServerStatUptime').textContent = t.lbl_stat_uptime;
  $('#lblServerStatCommunity').textContent = t.lbl_stat_community;
  $('#titleAnnouncement').textContent = t.title_announcement;
  $('#titleRules').textContent = t.title_rules;
  
  // Onay Modalı
  $('#confirmTitle').textContent = t.confirm_title;
  $('#confirmDesc').textContent = t.confirm_desc;
  $('#btnConfirmYes').textContent = t.confirm_yes;
  $('#btnConfirmNo').textContent = t.confirm_no;
}

function renderAll() {
  applyTranslations();

  const s = DATA.server;
  const p = DATA.player;
  
  // Sunucu Adı ve Oyuncu ID
  $('#serverName').textContent = s.name;
  $('#pId').textContent = p.id;
  
  // Saat güncellemesi
  updateClock();
  
  // Sol Alt Kartlar
  $('#cName').textContent = p.name;
  $('#cJob').textContent = p.job;
  $('#cCash').textContent = p.cash;
  $('#cBank').textContent = p.bank;
  
  // Topluluk Linki
  $('#lDiscord').textContent = s.discord;
  $('#lnkDiscordHref').href = 'https://' + s.discord;
  
  // Bilgi Paneli Detayları
  $('#iName').textContent = p.name;
  $('#iCid').textContent = p.cid;
  $('#iPhone').textContent = p.phone;
  $('#iJob').textContent = p.job;
  $('#iGang').textContent = p.gang;
  
  $('#iCash').textContent = p.cash;
  $('#iBank').textContent = p.bank;
  $('#iPlay').textContent = p.playtime;
  
  // Tuş Atamaları Listesi
  $('#keysList').innerHTML = (DATA.keys || []).map(k => `
    <div class="key">
      <span>${esc(k.a)}</span>
      <span class="kbd">${esc(k.k)}</span>
    </div>
  `).join('');
  
  // Oyuncu Sayaçları
  $('#sPlayers').textContent = s.players + ' / ' + s.max;
  $('#plCount').textContent = s.players + ' / ' + s.max;
  
  // Sunucu Bilgi Paneli
  $('#sUptime').textContent = s.uptime;
  $('#sDiscord').textContent = s.discord;
  $('#sAnnounce').textContent = s.announce;
  
  // Kurallar Listesi
  $('#sRules').innerHTML = (s.rules || []).map(r => `<li>${esc(r)}</li>`).join('');
  
  // Oyuncu Listesini Yazdır
  renderPlayers(DATA.players || []);
}

function renderPlayers(list) {
  $('#playersList').innerHTML = list.map(pl => `
    <div class="player">
      <div class="player-id">${esc(pl.id)}</div>
      <div class="player-n">${esc(pl.name)}</div>
      <div class="player-p">${esc(pl.ping)}ms</div>
    </div>
  `).join('');
}

function updateClock() {
  const d = new Date();
  $('#clock').textContent = String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
}

// Navigasyon Sekme Değişimi
$$('.nav-item[data-tab]').forEach(b => b.addEventListener('click', () => {
  const t = b.dataset.tab;
  $$('.nav-item').forEach(x => x.classList.remove('active'));
  b.classList.add('active');
  $$('.tab').forEach(x => x.classList.toggle('active', x.dataset.tab === t));
}));

// Oyun Ayarları ve Harita Yönlendirmeleri
$$('.nav-item[data-native]').forEach(b => b.addEventListener('click', () => {
  if (IN_GAME) post('openNative', { which: b.dataset.native });
}));

// Oyuncu Arama
$('#plSearch').addEventListener('input', e => {
  const q = e.target.value.toLowerCase();
  const filtered = (DATA.players || []).filter(p => 
    p.name.toLowerCase().includes(q) || String(p.id).includes(q)
  );
  renderPlayers(filtered);
});

// ESC ve Resume Kontrolü
$('#btnResume').addEventListener('click', closeMenu);

// Ayrıl / Disconnect Tetikleme (Onay Modalı Göster)
$('#btnDisconnect').addEventListener('click', () => {
  $('#confirmModal').classList.remove('hidden');
});

// Ayrılma Onay Modalı Butonları
$('#btnConfirmYes').addEventListener('click', () => {
  if (IN_GAME) {
    post('disconnect', {});
  } else {
    closeMenu();
    $('#confirmModal').classList.add('hidden');
  }
});

$('#btnConfirmNo').addEventListener('click', () => {
  $('#confirmModal').classList.add('hidden');
});

function post(cb, body) {
  fetch(`https://${RES}/${cb}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body || {})
  }).catch(() => {});
}

function openMenu() {
  $('#root').classList.remove('hidden');
}

function closeMenu() {
  $('#root').classList.add('hidden');
  if (IN_GAME) post('close', {});
}

// FiveM Event Dinleyicisi
window.addEventListener('message', e => {
  const d = e.data || {};
  if (d.action === 'open') {
    if (d.data) DATA = d.data;
    renderAll();
    openMenu();
  } else if (d.action === 'close') {
    closeMenu();
  } else if (d.action === 'data' && d.data) {
    DATA = d.data;
    renderAll();
  }
});

// Klavye ESC Yakalama
document.addEventListener('keyup', e => {
  if (e.key === 'Escape' && !$('#root').classList.contains('hidden')) {
    if (!$('#confirmModal').classList.contains('hidden')) {
      $('#confirmModal').classList.add('hidden');
    } else {
      closeMenu();
    }
  }
});

// Tarayıcı Testi Modu (Otomatik Başlat)
if (!IN_GAME) {
  renderAll();
  openMenu();
  // Canlı saat güncellemesi
  setInterval(updateClock, 10000);
}

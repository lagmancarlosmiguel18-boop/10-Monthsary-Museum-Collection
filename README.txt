BLUE + BACKGROUND MUSIC EDITION
===============================
INSTALL EXISTING SITE
1. Replace deployed index.html with this ZIP's index.html.
2. Run upgrade-background-music.sql in your project's SQL Editor.
3. If you skipped the earlier title editing upgrade, also run upgrade-title-editing.sql.
4. Do NOT rerun setup.sql on an existing project. New projects run setup.sql once.
5. Preserve your embedded PUBLIC backend URL/key if you customized those constants.

USE
Curate > Background music > Upload / replace song.
Choose MP3 (recommended), M4A, OGG or WAV, up to 25 MiB. Codec support varies.
One song loops automatically until paused, removed, or replaced. No song is bundled.
Use audio you own or have permission to use. Streaming-service links are not supported.
Local mode: anyone using this browser can choose its local song.
Online mode: only the room creator can change the shared song. Both members hear
that selection, but playback positions, volume, and pause are independent.
Tap Play music or the top music button if the browser blocks automatic playback.
Volume and pause preferences are remembered per browser. Music continues in Curate
and the memory viewer; lower or pause it manually when watching a video.
Closing/suspending the browser or device can stop playback. Looping is not a
promise of sample-accurate gapless playback; file encoding may introduce a short gap.
Local music is saved separately from memory uploads. Existing JSON memory backups
DO NOT include music. Keep the original song file and reupload when changing devices.
The online music bucket is private, with member reads and owner-only writes.
Shared song changes are polled approximately every five seconds during active use.
Audio URLs are refreshed after about 45 minutes. Bandwidth/storage quotas apply.

THEME
Soft blue walls, sky, interface accents and plaques, with warm floors/gold frames.
Existing character choices, Bogart animations, hidden names, and title editing remain.

VALIDATION
JavaScript syntax and DOM-reference checks passed. Earlier isolated avatar tests
still pass. Live audio playback, full WebGL visuals, and backend integration have
not been verified in this environment. Test with your two accounts after upgrading.
Autoplay reference: https://developer.mozilla.org/en-US/docs/Web/Media/Guides/Autoplay


EARLIER SETUP NOTES
CURATOR + BOO ANIMATION UPDATE
==============================
1. Replace your deployed index.html with the index.html in this ZIP.
2. EXISTING backend: run upgrade-title-editing.sql in SQL Editor. Do NOT rerun
   setup.sql on an existing installation. This adds owner-only title editing.
3. NEW backend: run setup.sql once; it already includes the title editing upgrade.
4. Preserve your embedded public backend settings if you previously customized them.

CHANGES
- Boo/Mica: lighter bouncy walk, gentle body sway, and three alternating idle
  gestures: wave, glasses-adjusting hand pose, and head-tilt/hand-to-chest pose.
- Carlos keeps a separate, calmer animation style.
- Removed ALL floating names above the local avatar, remote avatar, and Bogart.
  Account/connection names remain in the UI, not above 3D models.
- Curate: each exhibit has a title input, character count, Save title, Reset,
  and Remove. Press Enter in the title input to save. Titles allow 1-100 characters.
- Saved titles update wall plaques, viewer headings, and nearby exhibit hints.
- Local edits persist in browser storage and are included in exported backups.
- Online edits are owner-only and propagate through the existing exhibit polling.
- Editing a wall title does not rename or replace the underlying photo/video file.
- Unsaved title drafts survive panel refreshes during the current page session.

TESTING
JavaScript syntax, DOM references, archive integrity and isolated animation logic
are checked. Full rendering, media playback and live backend authorization have
not been verified here. Test with your two accounts after running the upgrade.


PREVIOUS SETUP NOTES
CARLOS POGI + BOO / MICA EDITION
Choose your character on the welcome screen:
- Carlos Pogi: chibi hoodie outfit, no cap, glasses, or face mask.
- Boo / Mica: chibi cap, round glasses, face mask, and teal-style hoodie.
Choosing a character fills its name automatically. For Mica, select Boo / Mica
and replace Boo in the name field with Mica. Names are shown above avatars.
Both characters retain walking/idle animations; Bogart keeps all animations.
Both visitors should deploy/use this version for matching online character styles.
No database changes required. Replace the deployed index.html with this ZIP's
index.html. Preserve any public backend settings previously embedded in HTML.
Visual appearance and live multiplayer remain unverified in this environment.

ANIMATED EDITION UPDATE
=======================
Deploy the index.html from this ZIP in place of your previous index.html.
No database migration is required if you already ran setup.sql.
Use this update on BOTH visitors' devices for outfit synchronization.
Keep the same deployed site origin to retain local browser uploads/settings.
If you previously embedded DEFAULT_URL / DEFAULT_KEY, copy those public settings
into the new HTML before deployment. Never embed secret/service-role keys.

NEW FEATURES
- Bogart: larger head, golden eyes with highlights, pink inner ears, curled tail.
- Four animated legs, walking bounce, occasional hops, tail swishes, ear twitches.
- Autonomous nearby roaming, catching up, sitting, sniffing, stretching, blinking.
- B key / Pet button within four world units triggers a purring-style pose and heart.
  This is a visual interaction, not an audio effect.
- Chibi proportions, sculpted fringe, layered outfit, cap/round-glasses/hoodie option.
- Select either look on the welcome screen; sweater colors still work.
- Animated arm/leg swings, breathing, head tilts, and walking bounce.
- Shared outfit choice uses a two-character marker in the existing player name
  field; online display names are therefore limited to 22 characters in this edition.
- Bogart remains locally simulated on each device, not network synchronized.
- These are original geometric 3D interpretations of the supplied references,
  not exact reproductions or imported high-detail character assets.

VALIDATION
JavaScript syntax, unique HTML IDs, DOM references, and ZIP integrity checked.
A Chromium launch succeeded, but the environment blocked the external 3D library
request. Visual appearance and live two-account integration remain unverified.

OUR LITTLE MUSEUM
=================
A romantic 3D browser museum for two people, with Bogart the black cat.

FILES
- index.html: complete game, styles, UI, admin view, and online client.
- setup.sql: backend schema, private storage bucket, access policies, and room functions.
- README.txt: these instructions.

QUICK START: LOCAL PREVIEW
1. Open index.html in a current browser with internet access and WebGL enabled.
2. Enter your name, choose a sweater, and select Step inside.
3. Select Curate to upload JPG, PNG, WebP, or MP4 files.
4. Local files persist in this browser's IndexedDB, not in the HTML itself.
5. Export local backup before clearing browser data or changing devices.
If opening the file directly fails, deploy it as described below. Some HTML runners
block module scripts, WebGL, storage, or external CDN requests; those runners are
not compatible. This is not a fully offline build: libraries load from a CDN.

DEPLOY
1. Make a folder containing index.html. Keep its name exactly index.html.
2. Drag that folder into Netlify Drop. No build command or npm install is needed.
3. Open the resulting site URL. Ensure your hosting visibility allows your partner
   to access it. You can also use any static HTTPS host that allows module scripts.
4. The curator view is available through Curate or by adding ?admin=1 to the URL.
   This URL is not an admin password. Online upload permission is enforced by RLS.

ONLINE SETUP: REQUIRED FOR DIFFERENT DEVICES
1. Create a Supabase project under your own account.
2. In SQL Editor, run setup.sql ONCE in a fresh project. Do not rerun it over an
   existing installation: the script intentionally does not overwrite tables.
3. Enable email/password sign-in under Authentication. Set your deployed site as
   the Auth Site URL and an allowed redirect URL. Keep email confirmation enabled;
   each person should confirm their email and then return to the game to sign in.
   Alternatively, create/confirm both accounts through your project dashboard.
4. Copy your project HTTPS URL and PUBLIC publishable key (or legacy anon key).
   NEVER use sb_secret_... or a service-role key in HTML or browser settings.
5. In the game, choose Together > Backend settings. Enter those public settings
   and save. Your partner must enter the SAME project settings on their device.
   Optional: edit DEFAULT_URL and DEFAULT_KEY near the start of the module in
   index.html before deployment so both devices receive the settings automatically.
6. Create separate accounts, confirm email if requested, and sign in.
7. One person selects Create our museum. This person is the curator/owner.
8. Copy the invitation code privately to the other person. They select Join museum.
9. Close the Together panel and explore. Both should now see each other's avatar.
10. The owner uploads memories using Curate while in ONLINE mode. Local preview
    uploads do not automatically migrate to a shared museum: upload them again.

CONTROLS
WASD / arrows: walk, relative to camera.
Drag scene: rotate camera. Scroll: zoom.
Click frame: open its memory. E: open a nearby exhibit.
H or heart button: send a floating heart. Escape: close panels.
Touch devices: arrow buttons to walk; drag the scene to look.

WHAT IS INCLUDED
- Full WebGL 3D gallery, pastel architecture, arch ribs, plants, benches, stars.
- Animated stylized avatars with five sweater choices.
- Bogart, a small black cat with a moving tail, following each visitor locally.
- 24 photo/video exhibits; images preserve their aspect ratio.
- MP4 player with controls. H.264 video/AAC audio is recommended.
- Owner-only shared uploads and removal, private bucket, signed media URLs.
- Two permanent member slots per museum, invitation code joining, account login.
- Local IndexedDB persistence and JSON backup/restore.
- Online avatar movement updates approximately every 0.9 seconds, with smoothing.
- Cloud exhibit changes checked about every 5 seconds.

LIMITS / IMPORTANT DETAILS
- Maximum 25 MiB per file, 24 exhibits per room. Compress large videos first.
- This is a lightweight multiplayer implementation using database polling, not
  a high-frequency authoritative game server. Latency depends on the connection.
- Bogart is simulated independently on each device; the cat is not synchronized.
- Video playback is independent on each device, not a synchronized watch party.
- Room membership is permanent in this version. Local mode disconnects your
  avatar but does not remove your membership. Create a new room if necessary.
- Keep invitation codes private. There is no password reset or membership
  management UI in this version; account recovery is handled in your dashboard.
- The app is not end-to-end encrypted. Your backend administrator can access data.
- Signed media links expire after one hour and are refreshed during active use.
  A copied signed link can remain usable until expiry. Do not share these links.
- Local backups contain your actual photos/videos. Keep backups private.
- There is no automatic cloud backup/export. Keep originals of your uploads.
- Storage, bandwidth, database polling, and hosting consume provider quotas.
  Monitor your project usage and configure spending controls before public use.
- Local storage availability and quotas vary by browser; private browsing may
  discard files. Large JSON backups can require substantial device memory.
- If the owner account is deleted, database rows cascade but stored objects may
  require manual cleanup in Storage. No account deletion UI is included.

VALIDATION STATUS
JavaScript module syntax was checked with Node. DOM ID references and uniqueness
were checked programmatically. The browser automation download was blocked in
this environment, so visual rendering, actual media playback, touch behavior,
and two-account backend integration were NOT verified in a live browser/project.
This is a complete implementation to deploy and test, not a zero-bug guarantee.

TWO-DEVICE ACCEPTANCE CHECKLIST
[ ] Open the deployed site in two separate browsers/devices.
[ ] Sign in with separate confirmed accounts and join the same room.
[ ] Verify both names/avatars appear and movement updates in both directions.
[ ] Upload one JPG and one H.264/AAC MP4 as owner; verify the guest sees both.
[ ] Verify guest upload/remove controls are disabled.
[ ] Verify an unrelated third account cannot join a full room or read its data.
[ ] Verify media bucket is private and an unsigned object URL is inaccessible.
[ ] Remove an exhibit and verify it disappears for the guest.
[ ] Reload and confirm the signed-in room and exhibits return.
[ ] Test local upload, reload, export, and restore separately from online mode.
[ ] Test on your phones and check performance and video codec compatibility.

REFERENCE DOCUMENTATION
https://docs.netlify.com/start/quickstarts/netlify-drop-quickstart/
https://supabase.com/docs/guides/storage/security/access-control
https://supabase.com/docs/reference/javascript

Libraries: Three.js (MIT) and supabase-js (MIT), loaded from jsDelivr.

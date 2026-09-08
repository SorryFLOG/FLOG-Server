$(function () {
    var webTranslations = {};

    var state = {
        open: false,
        bench: null,
        recipes: [],
        player: null,
        selectedIndex: 0,
        queue: [],
        maxQueueSize: 5,
        serverNow: 0,
        localAtServerNow: 0,
    };

    var $stage = $('.stage');
    var $itemName = $('.item-name');
    var $itemDesc = $('.item-desc');
    var $productImage = $('.product-image');
    var $ingredients = $('.ingredients');
    var $recipes = $('.recipes');
    var $btnCraft = $('.btn-craft');
    var $timePill = $('.time-row__pill');
    var $queueList = $('.queue-list');
    var $queueBody = $('.queue-body');
    var $queuePanel = $('.panel--queue');
    var $profileCard = $('.profile-card');
    var $profileInitials = $('.profile-card__initials');
    var $profileMugshot = $('.profile-card__mugshot');
    var $profileName = $('.profile-card__name');
    var $profileSub = $('.profile-card__sub');
    var $profileLevelNum = $('.profile-card__level-num');
    var $profileXpText = $('.profile-card__xp-text');
    var $profileBarFill = $('.profile-card__bar-fill');
    var $itemLevelPill = $('.item-level-pill');
    var $itemLevelNum = $('.item-level-pill__num');
    var $stageAdmin = $('.stage-admin');
    var $adminList = $('.admin-list');
    var $adminBody = $('.admin-body');
    var $adminConfirm = $('.admin-confirm');
    var $adminConfirmText = $('.admin-confirm__text');
    var $adminForm = $('.admin-form');
    var $adminFormTitle = $('.admin-form__title');
    var $adminFormRecipes = $('.admin-field__recipes');
    var $adminFormSearch = $('.admin-field__search');
    var $adminFormBlip = $('.admin-toggle[data-field="blip"]');
    var $adminFormNoProp = $('.admin-toggle[data-field="noProp"]');
    var adminOpen = false;
    var pendingDeleteKey = null;
    var adminRecipes = [];
    var formMode = null;
    var formEditKey = null;
    var formSelected = {};

    function post(event, payload, cb) {
        $.ajax({
            url: 'https://stg-crafting/' + event,
            type: 'POST',
            contentType: 'application/json; charset=UTF-8',
            data: JSON.stringify(payload || {}),
            success: function (data) { if (cb) cb(data); },
            error: function () { if (cb) cb(null); },
        });
    }

    function t(key, fallback) {
        if (webTranslations && webTranslations[key] !== undefined) return webTranslations[key];
        return fallback || key;
    }

    function applyWebTranslations(translations) {
        if (!translations) return;
        webTranslations = translations;
        $('[lang-data]').each(function () {
            var key = $(this).attr('lang-data');
            if (translations[key] !== undefined) {
                $(this).text(translations[key]);
            }
        });
        $('[lang-html]').each(function () {
            var key = $(this).attr('lang-html');
            if (translations[key] !== undefined) {
                $(this).html(translations[key]);
            }
        });
        $('[lang-data-placeholder]').each(function () {
            var key = $(this).attr('lang-data-placeholder');
            if (translations[key] !== undefined) {
                $(this).attr('placeholder', translations[key]);
            }
        });
    }

    function applyTheme(name) {
        if (!name) return;
        var $link = $('#theme-stylesheet');
        if (!$link.length) return;
        var target = '../shared/themes/' + name + '.css';
        if ($link.attr('href') !== target) $link.attr('href', target);
    }

    function formatTime(seconds) {
        seconds = parseInt(seconds, 10) || 0;
        if (seconds >= 60) {
            var m = Math.floor(seconds / 60);
            if (m >= 60) {
                var h = Math.floor(m / 60);
                return h + ' ' + t('ui_hours_short', 'h');
            }
            return m + ' ' + t('ui_minutes_short', 'Min');
        }
        return seconds + ' ' + t('ui_seconds_short', 'Sec');
    }

    function formatTimeLong(seconds) {
        seconds = parseInt(seconds, 10) || 0;
        if (seconds >= 60) {
            var m = Math.floor(seconds / 60);
            return m + ' ' + t('ui_minutes_word', 'Minutes');
        }
        return seconds + ' ' + t('ui_seconds_word', 'Seconds');
    }

    function imagePath(image) {
        if (!image) return '';
        if (/^https?:\/\//i.test(image)) return image;
        return 'assets/img/' + image;
    }

    function inventoryCount(item) {
        if (!state.player || !state.player.inventory) return 0;
        return state.player.inventory[item] || 0;
    }

    function recipeHasMaterials(recipe) {
        if (!recipe || !recipe.ingredients) return false;
        for (var i = 0; i < recipe.ingredients.length; i++) {
            var ing = recipe.ingredients[i];
            if (inventoryCount(ing.item) < ing.count) return false;
        }
        return true;
    }

    function playerLevel() {
        return (state.player && parseInt(state.player.level, 10)) || 1;
    }

    function recipeRequiredLevel(recipe) {
        return parseInt(recipe && recipe.minLevel, 10) || 0;
    }

    function recipeMeetsLevel(recipe) {
        return playerLevel() >= recipeRequiredLevel(recipe);
    }

    function buildInitials(first, last) {
        var a = (first || '').trim().charAt(0);
        var b = (last || '').trim().charAt(0);
        var result = (a + b).toUpperCase();
        if (result.length === 0) return '??';
        return result;
    }

    function formatXp(value) {
        var n = parseInt(value, 10) || 0;
        if (n >= 1000) return (Math.floor(n / 100) / 10) + 'k';
        return String(n);
    }

    function renderProfile() {
        var p = state.player;
        if (!p) {
            $profileCard.addClass('is-hidden');
            return;
        }
        $profileCard.removeClass('is-hidden');

        var first = p.firstname || '';
        var last = p.lastname || '';
        var fullName = (first + ' ' + last).trim();
        if (fullName.length === 0) fullName = t('ui_profile_unknown', 'Unknown');
        $profileInitials.text(buildInitials(first, last));
        $profileName.text(fullName);

        if (p.mugshot && String(p.mugshot).length > 0) {
            var url = 'https://nui-img/' + p.mugshot + '/' + p.mugshot;
            if ($profileMugshot.attr('src') !== url) $profileMugshot.attr('src', url);
            $profileCard.addClass('has-mugshot');
        } else {
            $profileCard.removeClass('has-mugshot');
            $profileMugshot.removeAttr('src');
        }

        var rankLabel = (p.rank && String(p.rank).length > 0) ? p.rank : t('ui_profile_subtitle', 'Crafter');
        $profileSub.text(rankLabel);

        if (p.levelEnabled === false) {
            $profileCard.find('.profile-card__level').css('display', 'none');
            return;
        }
        $profileCard.find('.profile-card__level').css('display', '');

        var level = parseInt(p.level, 10) || 0;
        var xp = parseInt(p.xp, 10) || 0;
        var need = parseInt(p.xpNeeded, 10) || 0;
        var maxLevel = parseInt(p.maxLevel, 10) || 0;
        var isMax = maxLevel > 0 && level >= maxLevel;

        $profileLevelNum.text(level);

        if (isMax) {
            $profileCard.addClass('is-max');
            $profileXpText.text(t('ui_profile_max', 'MAX'));
            $profileBarFill.css('width', '100%');
        } else {
            $profileCard.removeClass('is-max');
            $profileXpText.text(formatXp(xp) + ' / ' + formatXp(need) + ' XP');
            var pct = need > 0 ? Math.min(100, Math.max(0, (xp / need) * 100)) : 0;
            $profileBarFill.css('width', pct + '%');
        }
    }

    function renderSelected() {
        var recipe = state.recipes[state.selectedIndex];
        if (!recipe) return;

        $itemName.text(recipe.label || '');
        $itemDesc.text(recipe.description || '');

        var req = recipeRequiredLevel(recipe);
        if (req > 0) {
            $itemLevelPill.removeClass('is-hidden');
            $itemLevelPill.toggleClass('is-locked', !recipeMeetsLevel(recipe));
            $itemLevelNum.text(req);
        } else {
            $itemLevelPill.addClass('is-hidden');
        }

        $productImage.attr('src', imagePath(recipe.image));
        $productImage.off('error.craft').on('error.craft', function () {
            $(this).attr('src', 'assets/img/weapon_placeholder.png');
        });

        $timePill.text(formatTimeLong(recipe.craftTime));

        renderIngredients(recipe);
        updateCraftButton(recipe);
    }

    function renderIngredients(recipe) {
        $ingredients.empty();
        var list = recipe.ingredients || [];
        for (var i = 0; i < list.length; i++) {
            var ing = list[i];
            var have = inventoryCount(ing.item);
            var missing = have < ing.count;

            var $slot = $(
                '<div class="ingredient' + (missing ? ' ingredient--missing' : '') + '">' +
                    '<div class="ingredient__slot">' +
                        '<span class="ingredient__badge">x' + ing.count + '</span>' +
                        '<img class="ingredient__img" src="' + imagePath(ing.image || 'ingredient_placeholder.png') + '" alt="">' +
                    '</div>' +
                    '<div class="ingredient__name"></div>' +
                '</div>'
            );
            $slot.find('.ingredient__name').text(ing.label || ing.item || '');
            $slot.find('.ingredient__img').on('error', function () {
                $(this).attr('src', 'assets/img/ingredient_placeholder.png');
            });
            $ingredients.append($slot);
        }
    }

    function updateCraftButton(recipe) {
        var hasMats = recipeHasMaterials(recipe);
        var queueFull = state.queue.length >= (state.maxQueueSize || 5);
        var meetsLevel = recipeMeetsLevel(recipe);
        $btnCraft.prop('disabled', !hasMats || queueFull || !meetsLevel);
    }

    function serverTimeNow() {
        if (!state.serverNow) return 0;
        var elapsed = (Date.now() / 1000) - state.localAtServerNow;
        return state.serverNow + elapsed;
    }

    function formatRemaining(seconds) {
        seconds = Math.max(0, Math.floor(seconds));
        if (seconds <= 0) return t('ui_queue_ready', 'Ready');
        var minShort = t('ui_minutes_short', 'Min');
        var secShort = t('ui_seconds_short', 'Sec');
        if (seconds >= 60) {
            var m = Math.floor(seconds / 60);
            var s = seconds % 60;
            if (s === 0) return m + ' ' + minShort;
            return m + ' ' + minShort + ' ' + s + ' ' + secShort;
        }
        return seconds + ' ' + secShort;
    }

    function queueSlotTimeText(item, index) {
        if (index === 0) {
            var remaining = Math.max(0, (item.endsAt || 0) - serverTimeNow());
            return formatRemaining(remaining);
        }
        return formatRemaining(item.craftTime || 0);
    }

    function renderQueue() {
        $queueList.empty();
        var items = state.queue || [];
        if (items.length === 0) {
            $queueBody.removeClass('has-items');
            $queuePanel.removeClass('is-visible');
            return;
        }
        $queueBody.addClass('has-items');
        $queuePanel.addClass('is-visible');
        for (var i = 0; i < items.length; i++) {
            var q = items[i];
            var $slot = $(
                '<div class="queue-slot' + (i === 0 ? ' active' : '') + '" data-index="' + (i + 1) + '">' +
                    '<span class="queue-slot__index">' + (i + 1) + '</span>' +
                    '<button class="queue-slot__cancel" type="button" data-action="cancel-queue" aria-label="Cancel">' +
                        '<svg viewBox="0 0 10 10" fill="none" stroke-width="1.6" stroke-linecap="round" aria-hidden="true">' +
                            '<line x1="2" y1="2" x2="8" y2="8"/>' +
                            '<line x1="8" y1="2" x2="2" y2="8"/>' +
                        '</svg>' +
                    '</button>' +
                    '<div class="queue-slot__image"><img alt=""></div>' +
                    '<div class="queue-slot__info">' +
                        '<span class="queue-slot__name"></span>' +
                        '<span class="queue-slot__time"></span>' +
                    '</div>' +
                '</div>'
            );
            $slot.find('.queue-slot__name').text(q.label || q.recipeId || '');
            $slot.find('.queue-slot__time').text(queueSlotTimeText(q, i));
            var $img = $slot.find('.queue-slot__image img');
            $img.attr('src', imagePath(q.image));
            $img.on('error', function () {
                $(this).attr('src', 'assets/img/weapon_placeholder.png');
            });
            $queueList.append($slot);
        }
    }

    function refreshQueueTimes() {
        if (!state.queue || state.queue.length === 0) return;
        var head = state.queue[0];
        if (!head) return;
        var remaining = Math.max(0, (head.endsAt || 0) - serverTimeNow());
        $queueList.find('.queue-slot').first().find('.queue-slot__time').text(formatRemaining(remaining));
    }

    function renderRecipes() {
        $recipes.empty();
        for (var i = 0; i < state.recipes.length; i++) {
            var r = state.recipes[i];
            var req = recipeRequiredLevel(r);
            var locked = req > 0 && !recipeMeetsLevel(r);
            var classes = 'recipe';
            if (i === state.selectedIndex) classes += ' active';
            if (locked) classes += ' is-locked';

            var $card = $(
                '<div class="' + classes + '" data-index="' + i + '">' +
                    '<span class="recipe__time"></span>' +
                    '<div class="recipe__image"><img alt=""></div>' +
                    '<span class="recipe__name"></span>' +
                '</div>'
            );
            $card.find('.recipe__time').text(formatTime(r.craftTime));
            $card.find('.recipe__name').text(r.label || '');

            if (req > 0) {
                var $level = $('<span class="recipe__level"></span>').text('LVL ' + req);
                $card.append($level);
            }

            if (locked) {
                $card.append(
                    '<div class="recipe__lock">' +
                        '<svg viewBox="0 0 24 24" aria-hidden="true">' +
                            '<rect x="5" y="11" width="14" height="10" rx="1.5"/>' +
                            '<path d="M8 11V8a4 4 0 0 1 8 0v3"/>' +
                        '</svg>' +
                    '</div>'
                );
            }

            var $img = $card.find('.recipe__image img');
            $img.attr('src', imagePath(r.image));
            $img.on('error', function () {
                $(this).attr('src', 'assets/img/weapon_placeholder.png');
            });
            $recipes.append($card);
        }
        updateArrows();
    }

    function updateArrows() {
        var el = $recipes[0];
        if (!el) return;
        var max = el.scrollWidth - el.clientWidth;
        var pos = el.scrollLeft;
        $('.arrow--prev').css('opacity', pos > 0 ? 0.85 : 0.3);
        $('.arrow--next').css('opacity', pos < max - 1 ? 0.85 : 0.3);
    }

    function scrollToSelected() {
        var $card = $recipes.find('.recipe[data-index="' + state.selectedIndex + '"]');
        if (!$card.length) return;
        var el = $recipes[0];
        var cardLeft = $card[0].offsetLeft;
        var cardRight = cardLeft + $card[0].offsetWidth;
        var viewLeft = el.scrollLeft;
        var viewRight = viewLeft + el.clientWidth;
        if (cardLeft < viewLeft) {
            $recipes.stop().animate({ scrollLeft: cardLeft }, 220, updateArrows);
        } else if (cardRight > viewRight) {
            $recipes.stop().animate({ scrollLeft: cardRight - el.clientWidth }, 220, updateArrows);
        }
    }

    function selectRecipe(index) {
        if (index < 0 || index >= state.recipes.length) return;
        state.selectedIndex = index;
        renderSelected();
        $recipes.find('.recipe').removeClass('active');
        $recipes.find('.recipe[data-index="' + index + '"]').addClass('active');
        scrollToSelected();
    }

    function scrollCarousel(dir) {
        var $card = $recipes.find('.recipe').first();
        if (!$card.length) return;
        var cardWidth = $card.outerWidth();
        var gap = parseFloat($recipes.css('column-gap')) || parseFloat($recipes.css('gap')) || 0;
        var step = cardWidth + gap;
        var el = $recipes[0];
        var max = el.scrollWidth - el.clientWidth;
        if (wheelRaf) { cancelAnimationFrame(wheelRaf); wheelRaf = 0; }
        wheelTarget = null;
        var target;
        if (dir < 0) {
            var idxL = Math.ceil(el.scrollLeft / step - 0.01) - 1;
            target = Math.max(0, idxL * step);
        } else {
            var idxR = Math.floor(el.scrollLeft / step + 0.01) + 1;
            target = Math.min(max, idxR * step);
        }
        $recipes.stop(true).animate({ scrollLeft: target }, 260, updateArrows);
    }

    function sortRecipesByLevel(list) {
        if (!list || list.length < 2) return list || [];
        return list.slice().sort(function (a, b) {
            var la = parseInt(a && a.minLevel, 10) || 0;
            var lb = parseInt(b && b.minLevel, 10) || 0;
            if (la !== lb) return la - lb;
            return (a.label || '').localeCompare(b.label || '');
        });
    }

    function open(data) {
        state.open = true;
        state.bench = data.bench || null;
        state.recipes = sortRecipesByLevel(data.recipes || []);
        state.player = data.player || null;
        state.selectedIndex = 0;
        state.queue = (data.player && data.player.queue) || [];
        state.maxQueueSize = (data.player && data.player.maxQueueSize) || 5;
        state.serverNow = data.now || 0;
        state.localAtServerNow = Date.now() / 1000;

        applyTheme(data.theme);
        renderProfile();
        renderSelected();
        renderRecipes();
        renderQueue();
        $recipes.scrollLeft(0);
        updateArrows();

        $stage.addClass('is-open');
    }

    function close() {
        if (!state.open) return;
        state.open = false;
        $stage.removeClass('is-open');
    }

    function craft() {
        if ($btnCraft.prop('disabled')) return;
        var recipe = state.recipes[state.selectedIndex];
        if (!recipe) return;
        post('enqueue', { recipeId: recipe.id }, function (res) {
            if (!res || !res.ok) return;
            if (res.payload) {
                if (res.payload.queue) state.queue = res.payload.queue;
                if (res.payload.inventory && state.player) state.player.inventory = res.payload.inventory;
            }
            renderQueue();
            renderSelected();
        });
    }

    function cancelQueueItem(index) {
        post('cancelQueue', { index: index }, function (res) {
            if (!res || !res.ok) return;
            if (res.payload && res.payload.queue) state.queue = res.payload.queue;
            post('refreshInventory', {}, function (r) {
                if (r && r.ok && r.player) {
                    state.player = r.player;
                    if (r.player.queue) state.queue = r.player.queue;
                }
                renderQueue();
                renderSelected();
            });
        });
    }

    function renderAdminList(benches) {
        $adminList.empty();
        if (!benches || benches.length === 0) {
            $adminBody.removeClass('has-items');
            return;
        }
        $adminBody.addClass('has-items');
        for (var i = 0; i < benches.length; i++) {
            var b = benches[i];
            var tagClass = b.custom ? 'admin-row__tag--custom' : 'admin-row__tag--builtin';
            var tagKey = b.custom ? 'ui_admin_custom' : 'ui_admin_builtin';
            var coordText = b.coords ? (b.coords.x + ', ' + b.coords.y + ', ' + b.coords.z) : '';
            var recipeCount = (b.recipeCount || 0) + ' ' + t('ui_admin_recipes', 'recipes');

            var $row = $(
                '<div class="admin-row" data-key="' + b.key + '" data-custom="' + (b.custom ? '1' : '0') + '">' +
                    '<div class="admin-row__info">' +
                        '<div class="admin-row__key">' +
                            '<span class="admin-row__key-text"></span>' +
                            '<span class="admin-row__tag ' + tagClass + '"></span>' +
                        '</div>' +
                        '<div class="admin-row__meta"></div>' +
                    '</div>' +
                    '<div class="admin-row__actions">' +
                        '<button class="admin-btn" data-action="admin-teleport" type="button"></button>' +
                        '<button class="admin-btn" data-action="admin-edit" type="button"' + (b.custom ? '' : ' disabled') + '></button>' +
                        '<button class="admin-btn admin-btn--danger" data-action="admin-delete" type="button"' + (b.custom ? '' : ' disabled') + '></button>' +
                    '</div>' +
                '</div>'
            );
            $row.find('.admin-row__key-text').text(b.key);
            $row.find('.admin-row__tag').text(t(tagKey, b.custom ? 'CUSTOM' : 'BUILT-IN'));
            $row.find('.admin-row__meta').text(coordText + '  •  ' + recipeCount);
            $row.find('[data-action="admin-teleport"]').text(t('ui_admin_teleport', 'Teleport'));
            $row.find('[data-action="admin-edit"]').text(t('ui_admin_edit', 'Edit'));
            $row.find('[data-action="admin-delete"]').text(t('ui_admin_delete', 'Delete'));
            $adminList.append($row);
        }
    }

    function renderRecipeCheckboxes(filter) {
        $adminFormRecipes.empty();
        var needle = (filter || '').toLowerCase();
        for (var i = 0; i < adminRecipes.length; i++) {
            var r = adminRecipes[i];
            if (needle && (r.label || r.id).toLowerCase().indexOf(needle) === -1) continue;
            var checked = !!formSelected[r.id];
            var $row = $(
                '<label class="admin-recipe' + (checked ? ' checked' : '') + '" data-recipe="' + r.id + '">' +
                    '<span class="admin-recipe__box"></span>' +
                    '<span class="admin-recipe__label"></span>' +
                '</label>'
            );
            $row.find('.admin-recipe__label').text(r.label || r.id);
            $adminFormRecipes.append($row);
        }
    }

    function openForm(mode, data) {
        formMode = mode;
        formEditKey = (data && data.key) || null;
        formSelected = {};
        var titleKey = mode === 'edit' ? 'ui_admin_form_edit_title' : 'ui_admin_form_create_title';
        var titleText = t(titleKey, mode === 'edit' ? 'Edit Bench' : 'Create Bench');
        if (mode === 'edit' && formEditKey) titleText = titleText + ' · ' + formEditKey;
        $adminFormTitle.text(titleText);

        var defaults = (data && data.defaults) || {};
        $adminForm.find('[data-field="minLevel"]').val(defaults.minLevel || 0);
        $adminForm.find('[data-field="restrictionType"]').val(defaults.restrictionType === 'gang' ? 'gang' : 'job');
        $adminForm.find('[data-field="restrictionName"]').val(defaults.restrictionName || '');
        var propValue = defaults.propModel != null ? defaults.propModel : 'prop_tool_bench02';
        var noPropChecked = mode === 'edit' && propValue === '';
        $adminForm.find('[data-field="propModel"]').val(noPropChecked ? '' : (propValue || 'prop_tool_bench02'));
        $adminFormNoProp.toggleClass('checked', noPropChecked);
        $adminFormBlip.toggleClass('checked', !!defaults.blip);

        var preset = (defaults.recipes || []);
        for (var i = 0; i < preset.length; i++) formSelected[preset[i]] = true;

        $adminFormSearch.val('');
        renderRecipeCheckboxes('');
        $adminForm.addClass('is-open');
    }

    function closeForm() {
        $adminForm.removeClass('is-open');
        formMode = null;
        formEditKey = null;
        formSelected = {};
    }

    function submitForm() {
        var selected = [];
        for (var id in formSelected) if (formSelected[id]) selected.push(id);
        if (selected.length === 0) return;

        var noProp = $adminFormNoProp.hasClass('checked');
        var payload = {
            mode: formMode,
            key: formEditKey,
            minLevel: parseInt($adminForm.find('[data-field="minLevel"]').val(), 10) || 0,
            restrictionType: $adminForm.find('[data-field="restrictionType"]').val() || 'job',
            restrictionName: ($adminForm.find('[data-field="restrictionName"]').val() || '').trim(),
            propModel: noProp ? '' : ($adminForm.find('[data-field="propModel"]').val() || '').trim(),
            noProp: noProp,
            blip: $adminFormBlip.hasClass('checked'),
            recipes: selected,
        };
        closeForm();
        post('adminFormSubmit', payload, function () {});
    }

    function openAdmin(data) {
        adminOpen = true;
        adminRecipes = data.recipes || adminRecipes;
        applyTheme(data.theme);
        renderAdminList(data.benches || []);
        $stageAdmin.addClass('is-open');
    }

    function closeAdmin() {
        if (!adminOpen) return;
        adminOpen = false;
        $stageAdmin.removeClass('is-open');
    }

    window.addEventListener('message', function (event) {
        var data = event.data || {};
        if (data.action === 'setTranslations') { applyWebTranslations(data.translations || {}); return; }
        if (data.action === 'admin-open') { openAdmin(data); return; }
        if (data.action === 'admin-close') { closeAdmin(); return; }
        if (data.action === 'admin-refresh') { renderAdminList(data.benches || []); return; }
        if (data.action === 'open') open(data);
        else if (data.action === 'close') close();
        else if (data.action === 'updatePlayer') {
            state.player = data.player || state.player;
            if (data.player && data.player.queue) state.queue = data.player.queue;
            renderProfile();
            renderRecipes();
            renderQueue();
            renderSelected();
        } else if (data.action === 'updateQueue') {
            state.queue = data.queue || [];
            if (data.now) {
                state.serverNow = data.now;
                state.localAtServerNow = Date.now() / 1000;
            }
            renderQueue();
            post('refreshInventory', {}, function (r) {
                if (r && r.ok && r.player) {
                    state.player = r.player;
                }
                renderProfile();
                renderRecipes();
                renderSelected();
            });
        }
    });

    $(document).on('keydown', function (e) {
        if (adminOpen) {
            if (e.key === 'Escape') {
                if ($adminConfirm.hasClass('is-open')) {
                    pendingDeleteKey = null;
                    $adminConfirm.removeClass('is-open');
                    return;
                }
                if ($adminForm.hasClass('is-open')) {
                    closeForm();
                    return;
                }
                post('adminClose', {}, function () { closeAdmin(); });
            }
            return;
        }
        if (!state.open) return;
        if (e.key === 'Escape') {
            post('close', {}, function () { close(); });
        } else if (e.key === 'ArrowLeft') {
            scrollCarousel(-1);
        } else if (e.key === 'ArrowRight') {
            scrollCarousel(1);
        } else if (e.key === 'Enter') {
            craft();
        }
    });

    $(document).on('click', '[data-action]', function () {
        var action = $(this).attr('data-action');
        if (action === 'close') post('close', {}, function () { close(); });
        else if (action === 'craft') craft();
        else if (action === 'prev') scrollCarousel(-1);
        else if (action === 'next') scrollCarousel(1);
        else if (action === 'admin-teleport') {
            var key = $(this).closest('.admin-row').attr('data-key');
            post('adminTeleport', { key: key }, function () {});
        } else if (action === 'admin-delete') {
            var key = $(this).closest('.admin-row').attr('data-key');
            pendingDeleteKey = key;
            var tmpl = t('ui_admin_confirm_text', 'Bench %s will be permanently removed.');
            $adminConfirmText.text(tmpl.replace('%s', key));
            $adminConfirm.addClass('is-open');
        } else if (action === 'admin-new') {
            post('adminRequestForm', { mode: 'create' }, function (res) {
                openForm('create', { defaults: (res && res.defaults) || {} });
            });
        } else if (action === 'admin-edit') {
            var eKey = $(this).closest('.admin-row').attr('data-key');
            post('adminRequestForm', { mode: 'edit', key: eKey }, function (res) {
                openForm('edit', { key: eKey, defaults: (res && res.defaults) || {} });
            });
        } else if (action === 'admin-form-cancel') {
            closeForm();
        } else if (action === 'admin-form-submit') {
            submitForm();
        } else if (action === 'admin-confirm-cancel') {
            pendingDeleteKey = null;
            $adminConfirm.removeClass('is-open');
        } else if (action === 'admin-confirm-yes') {
            var dkey = pendingDeleteKey;
            pendingDeleteKey = null;
            $adminConfirm.removeClass('is-open');
            if (!dkey) return;
            post('adminDelete', { key: dkey }, function (res) {
                if (res && res.benches) renderAdminList(res.benches);
            });
        }
    });

    $(document).on('click', '.recipe', function () {
        var idx = parseInt($(this).attr('data-index'), 10);
        if (!isNaN(idx)) selectRecipe(idx);
    });

    $(document).on('click', '.admin-recipe', function (e) {
        e.preventDefault();
        var id = $(this).attr('data-recipe');
        if (!id) return;
        formSelected[id] = !formSelected[id];
        $(this).toggleClass('checked', !!formSelected[id]);
    });

    $adminFormSearch.on('input', function () {
        renderRecipeCheckboxes($(this).val());
    });

    $adminFormBlip.on('click', function () {
        $(this).toggleClass('checked');
    });

    $adminFormNoProp.on('click', function () {
        $(this).toggleClass('checked');
    });

    $recipes.on('scroll', updateArrows);

    var wheelTarget = null;
    var wheelRaf = 0;

    function wheelTick() {
        var el = $recipes[0];
        if (!el || wheelTarget === null) { wheelRaf = 0; return; }
        var current = el.scrollLeft;
        var diff = wheelTarget - current;
        if (Math.abs(diff) < 0.5) {
            el.scrollLeft = wheelTarget;
            wheelTarget = null;
            wheelRaf = 0;
            updateArrows();
            return;
        }
        el.scrollLeft = current + diff * 0.18;
        wheelRaf = requestAnimationFrame(wheelTick);
    }

    $recipes.on('wheel', function (e) {
        var oe = e.originalEvent;
        var delta = Math.abs(oe.deltaX) > Math.abs(oe.deltaY) ? oe.deltaX : oe.deltaY;
        if (!delta) return;
        e.preventDefault();
        var el = $recipes[0];
        var max = el.scrollWidth - el.clientWidth;
        var base = wheelTarget !== null ? wheelTarget : el.scrollLeft;
        wheelTarget = Math.max(0, Math.min(max, base + delta));
        $recipes.stop(true);
        if (!wheelRaf) wheelRaf = requestAnimationFrame(wheelTick);
    });

    $(document).on('click', '.queue-slot__cancel', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var $slot = $(this).closest('.queue-slot');
        var idx = parseInt($slot.attr('data-index'), 10);
        if (!isNaN(idx)) cancelQueueItem(idx);
    });

    $(document).on('contextmenu', function (e) { e.preventDefault(); });

    setInterval(function () {
        if (!state.open) return;
        refreshQueueTimes();
    }, 1000);

    post('ready', {});

    if (typeof GetParentResourceName !== 'function') {
        window.postMessage({
            action: 'setTranslations',
            translations: {
                ui_title_bold: 'CRAFTING',
                ui_title_light: 'System',
                ui_needs_for_crafting: 'NEEDS FOR CRAFTING',
                ui_what_can_craft: 'WHAT CAN I CRAFT?',
                ui_craft_button: 'Craft',
                ui_crafting_time: 'Crafting time',
                ui_minutes_short: 'Min',
                ui_seconds_short: 'Sec',
                ui_minutes_word: 'Minutes',
                ui_seconds_word: 'Seconds',
                ui_queue_title: 'QUEUE',
                ui_queue_empty: 'Empty',
                ui_queue_cancel_hint: 'Right-click to cancel',
                ui_queue_ready: 'Ready',
            },
        }, '*');
        window.postMessage({
            action: 'open',
            theme: 'blue',
            bench: { key: 'bench_weapon_1', label: 'Weapon Crafting Bench' },
            recipes: [
                {
                    id: 'm4a9_nike',
                    label: 'M4A9- NIKE EDITION',
                    description: 'Custom M4A9 carbine rifle with Nike-inspired aesthetic finish.',
                    image: 'weapon_placeholder.png',
                    craftTime: 900,
                    minLevel: 3,
                    ingredients: [
                        { item: 'steel', count: 2, label: 'Steel' },
                        { item: 'plastic', count: 2, label: 'Plastic' },
                        { item: 'rubber', count: 2, label: 'Rubber' },
                        { item: 'electronics', count: 2, label: 'Electronics' },
                        { item: 'weapon_parts', count: 2, label: 'Weapon Parts' },
                        { item: 'gunpowder', count: 2, label: 'Gunpowder' },
                    ],
                },
                { id: 'ak47_custom', label: 'AK-47 Custom', description: 'A customized AK-47.', image: 'weapon_placeholder.png', craftTime: 480, minLevel: 1, ingredients: [] },
                { id: 'pistol_mk2', label: 'Pistol MK2', description: 'Upgraded pistol.', image: 'weapon_placeholder.png', craftTime: 300, minLevel: 5, ingredients: [] },
                { id: 'combat_pdw', label: 'Combat PDW', description: 'Compact PDW.', image: 'weapon_placeholder.png', craftTime: 420, minLevel: 10, ingredients: [] },
                { id: 'pistol_1', label: 'Pistol', description: 'Basic pistol.', image: 'weapon_placeholder.png', craftTime: 180, minLevel: 0, ingredients: [] },
                { id: 'smg_1', label: 'SMG', description: 'Submachine gun.', image: 'weapon_placeholder.png', craftTime: 360, minLevel: 20, ingredients: [] },
            ],
            now: Math.floor(Date.now() / 1000),
            player: {
                firstname: 'Baran',
                lastname: 'STG',
                level: 7,
                xp: 180,
                xpNeeded: 380,
                maxLevel: 50,
                levelEnabled: true,
                rank: 'Apprentice',
                inventory: { steel: 5, plastic: 5, rubber: 5, electronics: 5, weapon_parts: 5, gunpowder: 5 },
                maxQueueSize: 5,
                queue: [
                    { recipeId: 'ak47_custom', label: 'AK-47 Custom', image: 'weapon_placeholder.png', craftTime: 480, endsAt: Math.floor(Date.now() / 1000) + 180 },
                    { recipeId: 'pistol_mk2', label: 'Pistol MK2', image: 'weapon_placeholder.png', craftTime: 300, endsAt: Math.floor(Date.now() / 1000) + 420 },
                ],
            },
        }, '*');
    }
});
/* Diiwaanu Xassida Yi — JavaScript vanilla, aucune dépendance, aucun suivi. */
(() => {
  'use strict';

  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => Array.from(root.querySelectorAll(selector));

  /* ---------- Menu hamburger ---------- */
  function initMenu() {
    const toggle = $('[data-menu-toggle]');
    const panel = $('#site-menu');
    const backdrop = $('[data-menu-backdrop]');
    const close = $('[data-menu-close]');
    if (!toggle || !panel || !backdrop) return;

    const setOpen = (open) => {
      panel.classList.toggle('is-open', open);
      backdrop.classList.toggle('is-open', open);
      toggle.setAttribute('aria-expanded', String(open));
      panel.setAttribute('aria-hidden', String(!open));
      document.body.classList.toggle('menu-open', open);
      if (open) {
        const first = $('a', panel);
        if (first) first.focus();
      } else {
        toggle.focus();
      }
    };

    toggle.addEventListener('click', () => {
      setOpen(toggle.getAttribute('aria-expanded') !== 'true');
    });
    backdrop.addEventListener('click', () => setOpen(false));
    if (close) close.addEventListener('click', () => setOpen(false));
    $$('a', panel).forEach((link) => link.addEventListener('click', () => setOpen(false)));
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && toggle.getAttribute('aria-expanded') === 'true') {
        setOpen(false);
      }
    });
  }

  /* ---------- Formulaire d’information (sans stockage) ---------- */
  function initNotifyForm() {
    const form = $('#notify-form');
    const status = $('#form-status');
    if (!form || !status) return;

    form.addEventListener('submit', (event) => {
      event.preventDefault();
      if (!form.checkValidity()) {
        form.reportValidity();
        return;
      }

      const email = form.elements.email.value.trim();
      const subject = encodeURIComponent('Information de la sortie — Diiwaanu Xassida Yi');
      const body = encodeURIComponent(
        `Bonjour,\n\nJe souhaite être informé de la mise en ligne de Diiwaanu Xassida Yi.\n\nAdresse e-mail : ${email}\n\nMerci.`
      );
      status.textContent = 'Votre messagerie va s’ouvrir avec le message prêt à envoyer.';
      window.location.href = `mailto:beguefallou@gmail.com?subject=${subject}&body=${body}`;
    });
  }

  /* ---------- Bibliothèque : recherche, langues, index A → Z ---------- */
  function initLibrary() {
    const list = $('#book-list');
    const count = $('#book-count');
    const alpha = $('#alpha-index');
    const search = $('#book-search');
    if (!list || !count || !search) return;

    const rows = $$('.book-row', list);
    if (!rows.length) return;

    const more = $('[data-more-books]');
    const step = 50;
    let limit = step;
    const state = { query: '', lang: 'Toutes', letter: 'Toutes' };

    const syncAlpha = () => {
      if (!alpha) return;
      $$('[data-letter]', alpha).forEach((button) => {
        button.setAttribute('aria-pressed', String(button.dataset.letter === state.letter));
      });
    };

    const uniqueLetters = Array.from(
      new Set(rows.map((row) => (row.dataset.letter || '#').toUpperCase()))
    ).sort((a, b) => {
      if (a === '#') return 1;
      if (b === '#') return -1;
      return a.localeCompare(b, 'fr');
    });

    if (alpha) {
      alpha.innerHTML = ['Toutes', ...uniqueLetters]
        .map((letter) => (
          `<button type="button" data-letter="${letter}" aria-pressed="${letter === 'Toutes'}">${letter}</button>`
        ))
        .join('');
    }

    const normalise = (value) => String(value || '')
      .toLocaleLowerCase('fr')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');

    const apply = () => {
      const query = normalise(state.query);
      let matching = 0;
      let shown = 0;

      rows.forEach((row) => {
        const title = normalise(row.dataset.title);
        const arabic = normalise(row.dataset.arabic);
        const lang = row.dataset.lang || '';
        const letter = (row.dataset.letter || '#').toUpperCase();
        const matchesQuery = !query || title.includes(query) || arabic.includes(query);
        const matchesLang = state.lang === 'Toutes' || lang === state.lang;
        const matchesLetter = state.letter === 'Toutes' || letter === state.letter;
        const show = matchesQuery && matchesLang && matchesLetter;
        row.hidden = !show;
        row.classList.remove('is-truncated');
        if (show) {
          matching += 1;
          if (shown < limit) {
            shown += 1;
          } else {
            row.classList.add('is-truncated');
          }
        }
      });

      const truncated = matching > shown;
      const word = matching > 1 ? 's' : '';
      const recap = truncated
        ? `${shown} khassaïde${shown > 1 ? 's' : ''} affichée${shown > 1 ? 's' : ''} sur ${matching}`
        : `${matching} khassaïde${word} affichée${word}`;
      count.textContent = state.query ? `Recherche « ${state.query} » — ${recap}` : recap;

      if (more) {
        more.hidden = !truncated;
        const next = Math.min(step, matching - shown);
        more.textContent = `Afficher ${next} khassaïde${next > 1 ? 's' : ''} de plus`;
      }
    };

    const reset = () => { limit = step; apply(); };

    const onSearch = (event) => {
      state.query = String(event.target.value || '').trim();
      /* Une recherche démarre toujours depuis la liste complète : une lettre
         restée active faisait sinon afficher « 0 résultat » sans explication. */
      state.letter = 'Toutes';
      syncAlpha();
      reset();
    };
    /* `input` suffit sur les navigateurs modernes ; `change` et `search`
       couvrent la validation clavier et le bouton « effacer » natif. */
    search.addEventListener('input', onSearch);
    search.addEventListener('change', onSearch);
    search.addEventListener('search', onSearch);

    $$('button[data-lang]').forEach((button) => {
      button.addEventListener('click', () => {
        state.lang = button.dataset.lang;
        $$('button[data-lang]').forEach((other) => {
          other.setAttribute('aria-pressed', String(other === button));
        });
        reset();
      });
    });

    if (alpha) {
      alpha.addEventListener('click', (event) => {
        const button = event.target.closest('[data-letter]');
        if (!button) return;
        /* Choisir une lettre efface la recherche : le clic montre toujours
           les khassaïdes de cette lettre, même après une recherche précédente. */
        state.letter = button.dataset.letter;
        state.query = '';
        search.value = '';
        syncAlpha();
        reset();
      });
    }

    if (more) more.addEventListener('click', () => { limit += step; apply(); });

    apply();
  }

  /* ---------- Retour rapide en haut, sur toutes les pages ---------- */
  function initToTop() {
    if ($('.to-top')) return;
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'to-top';
    button.setAttribute('aria-label', 'Retour en haut');
    button.innerHTML = '<span aria-hidden="true">↑</span>';
    document.body.appendChild(button);

    const update = () => button.classList.toggle('is-visible', window.scrollY > 400);
    window.addEventListener('scroll', update, { passive: true });
    update();

    button.addEventListener('click', () => {
      const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({ top: 0, behavior: reduced ? 'auto' : 'smooth' });
    });
  }



  /* ---------- Infos mourides : navigation interne et galerie agrandie ---------- */
  function initMourideNav() {
    const nav = $('.mouride-nav');
    if (!nav) return;
    const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    $$('a', nav).forEach((link) => {
      link.addEventListener('click', (event) => {
        const href = link.getAttribute('href') || '';
        if (!href.startsWith('#')) return;
        const target = $(href);
        if (!target) return;
        event.preventDefault();
        target.scrollIntoView({ behavior: reduced ? 'auto' : 'smooth', block: 'start' });
        if (history.replaceState) history.replaceState(null, '', href);
      });
    });
  }

  /* ---------- Bouton Conférences : sous-menu local, sans navigation automatique ---------- */
  function initConferenceMenu() {
    const toggle = $('[data-conferences-toggle]');
    const submenu = $('#conferences-submenu');
    if (!toggle || !submenu) return;

    const setOpen = (open) => {
      submenu.hidden = !open;
      toggle.setAttribute('aria-expanded', String(open));
    };

    toggle.addEventListener('click', () => {
      setOpen(toggle.getAttribute('aria-expanded') !== 'true');
    });
    $$('a', submenu).forEach((link) => {
      link.addEventListener('click', () => setOpen(false));
    });
    document.addEventListener('click', (event) => {
      if (!submenu.hidden && !toggle.contains(event.target) && !submenu.contains(event.target)) {
        setOpen(false);
      }
    });
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && !submenu.hidden) {
        setOpen(false);
        toggle.focus();
      }
    });
  }

  function initMourideGallery() {
    const dialog = $('#gallery-lightbox');
    const items = $$('.gallery-item');
    if (!dialog || !items.length) return;
    const image = $('#gallery-image');
    const caption = $('#gallery-caption');
    const close = $('[data-gallery-close]', dialog);

    const closeDialog = () => {
      if (dialog.close) dialog.close(); else dialog.removeAttribute('open');
      if (image) image.removeAttribute('src');
    };

    items.forEach((button) => {
      button.addEventListener('click', () => {
        const source = button.dataset.src || '';
        const label = button.dataset.caption || 'Portrait mouride';
        if (image) {
          image.src = source;
          image.alt = label;
        }
        if (caption) caption.textContent = label;
        if (dialog.showModal) dialog.showModal(); else dialog.setAttribute('open', '');
        if (close) close.focus();
      });
    });

    if (close) close.addEventListener('click', closeDialog);
    dialog.addEventListener('click', (event) => {
      if (event.target === dialog) closeDialog();
    });
    dialog.addEventListener('cancel', () => {
      if (image) image.removeAttribute('src');
    });
  }

  /* ---------- Playlist audio : lecture en ligne, aucun téléchargement ---------- */
  function initAudioPlaylist() {
    const player = $('#audio-player');
    const list = $('#playlist');
    const status = $('#audio-status');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = -1;

    const titleOf = (row) => row.dataset.title || 'cet enregistrement';

    const reflect = () => {
      rows.forEach((row, index) => {
        const playing = index === current && !player.paused;
        row.classList.toggle('is-current', index === current);
        const button = $('.playlist-play', row);
        if (button) {
          button.textContent = playing ? '❚❚' : '▶';
          button.setAttribute('aria-label', (playing ? 'Mettre en pause : ' : 'Lire : ') + titleOf(row));
        }
      });
    };

    const announce = (message) => {
      if (status) status.textContent = message;
    };

    const setTrack = (index, play) => {
      if (index < 0 || index >= rows.length) return;
      current = index;
      player.src = rows[index].dataset.src;
      player.load();
      announce('En cours : ' + titleOf(rows[index]));
      reflect();
      if (play) {
        const pending = player.play();
        if (pending && pending.catch) {
          pending.catch(() => announce('Lecture bloquée par le navigateur : utilisez le bouton du lecteur.'));
        }
      }
    };

    const toggle = (index) => {
      if (index !== current) {
        setTrack(index, true);
        return;
      }
      if (player.paused) {
        const pending = player.play();
        if (pending && pending.catch) pending.catch(() => announce('Lecture indisponible.'));
      } else {
        player.pause();
      }
    };

    rows.forEach((row, index) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => toggle(index));
    });

    const previous = $('[data-audio-prev]');
    const next = $('[data-audio-next]');
    if (previous) previous.addEventListener('click', () => {
      setTrack(current <= 0 ? rows.length - 1 : current - 1, true);
    });
    if (next) next.addEventListener('click', () => {
      setTrack(current >= rows.length - 1 ? 0 : current + 1, true);
    });

    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => {
      if (current < rows.length - 1) {
        setTrack(current + 1, true);
      } else {
        announce('Fin de la playlist.');
        reflect();
      }
    });
  }

  /* ---------- Recherche globale : index local, aucun envoi ---------- */
  function initGlobalSearch() {
    const input = $('#global-search');
    const results = $('#search-results');
    const status = $('#search-status');
    if (!input || !results || !status) return;
    const index = window.DIIWAANU_SEARCH_INDEX || [];
    let selected = 'Tous';

    const normalise = (value) => String(value || '')
      .toLocaleLowerCase('fr')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');

    const escapeHtml = (value) => String(value || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');

    const render = () => {
      const query = normalise(input.value.trim());
      status.textContent = query
        ? ''
        : index.length + ' entrées disponibles — tapez un mot pour chercher.';
      if (!query) {
        results.innerHTML = '';
        return;
      }
      const found = index.filter((item) => {
        if (selected !== 'Tous' && item.kind !== selected) return false;
        return normalise(String(item.title) + ' ' + String(item.text)).includes(query);
      }).slice(0, 40);

      status.textContent = found.length
        ? found.length + ' résultat' + (found.length > 1 ? 's' : '') + ' affiché' + (found.length > 1 ? 's' : '') + ' sur ' + index.length + ' entrées (40 maximum).'
        : 'Aucun résultat pour cette recherche.';

      if (!found.length) {
        results.innerHTML = '<p class="search-empty">Essayez un autre mot : un titre, une langue, un nom ou un chapitre.</p>';
        return;
      }
      results.innerHTML = found.map((item) => {
        const target = item.external ? ' target="_blank" rel="noopener"' : '';
        return '<a class="search-item" href="' + escapeHtml(item.url) + '"' + target + '>'
          + '<span class="search-kind">' + escapeHtml(item.kind) + '</span>'
          + '<span class="search-title">' + escapeHtml(item.title) + '</span>'
          + '<span class="search-snippet">' + escapeHtml(item.text) + '</span>'
          + '</a>';
      }).join('');
    };

    $$('[data-search-kind]').forEach((button) => {
      button.addEventListener('click', () => {
        selected = button.dataset.searchKind;
        $$('[data-search-kind]').forEach((other) => {
          other.setAttribute('aria-pressed', String(other === button));
        });
        render();
      });
    });

    input.addEventListener('input', render);
    input.addEventListener('search', render);
    render();
  }

  /* ---------- Rajaz : un seul lecteur, filtres locaux, aucun téléchargement ---------- */
  function initRajazPlaylist() {
    const player = $('#rajaz-player');
    const list = $('#rajaz-playlist');
    const status = $('#rajaz-status');
    const select = $('#rajaz-artist');
    const search = $('#rajaz-search');
    const count = $('#rajaz-count');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = null;

    const titleOf = (row) => row.dataset.title || 'cette khassida';
    const visible = () => rows.filter((row) => !row.hidden);

    const reflect = () => {
      rows.forEach((row) => {
        const playing = row === current && !player.paused;
        row.classList.toggle('is-current', row === current);
        const button = $('.playlist-play', row);
        if (button) {
          button.textContent = playing ? '❚❚' : '▶';
          button.setAttribute('aria-label', (playing ? 'Mettre en pause : ' : 'Lire : ') + titleOf(row));
        }
      });
    };

    const announce = (message) => {
      if (status) status.textContent = message;
    };

    const setTrack = (row, play) => {
      if (!row) return;
      current = row;
      player.src = row.dataset.src;
      player.load();
      announce('En cours : ' + titleOf(row));
      reflect();
      if (play) {
        const pending = player.play();
        if (pending && pending.catch) {
          pending.catch(() => announce('Lecture bloquée par le navigateur : utilisez le bouton du lecteur.'));
        }
      }
    };

    const step = (offset) => {
      const shown = visible();
      if (!shown.length) return;
      const index = shown.indexOf(current);
      const next = index < 0 ? 0 : (index + offset + shown.length) % shown.length;
      setTrack(shown[next], true);
    };

    const applyFilters = () => {
      const artist = select ? select.value : '';
      const query = search ? search.value.trim().toLowerCase() : '';
      let shown = 0;
      rows.forEach((row) => {
        const artistOk = !artist || row.dataset.artist === artist;
        const textOk = !query || (row.dataset.search || '').includes(query);
        row.hidden = !(artistOk && textOk);
        if (!row.hidden) shown++;
      });
      if (count) {
        count.textContent = shown + ' enregistrement' + (shown > 1 ? 's' : '');
      }
      if (current && current.hidden) {
        current = null;
        player.pause();
        player.removeAttribute('src');
        player.load();
        announce('Choisissez une khassida pour commencer l’écoute.');
      }
      reflect();
    };

    rows.forEach((row) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => setTrack(row, true));
    });
    const previous = $('[data-rajaz-prev]');
    const next = $('[data-rajaz-next]');
    if (previous) previous.addEventListener('click', () => step(-1));
    if (next) next.addEventListener('click', () => step(1));
    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => step(1));

    if (select) {
      const requested = new URLSearchParams(window.location.search).get('artiste');
      if (requested && rows.some((row) => row.dataset.artist === requested)) {
        select.value = requested;
      }
      select.addEventListener('change', applyFilters);
    }
    if (search) {
      search.addEventListener('input', applyFilters);
      search.addEventListener('search', applyFilters);
    }
    applyFilters();
  }

  /* ---------- FATWA : un seul lecteur, filtres locaux, aucun téléchargement ---------- */
  function initFatwaPlaylist() {
    const player = $('#fatwa-player');
    const list = $('#fatwa-playlist');
    const status = $('#fatwa-status');
    const select = $('#fatwa-author');
    const search = $('#fatwa-search');
    const count = $('#fatwa-count');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = null;

    const titleOf = (row) => row.dataset.title || 'cette question-réponse';
    const visible = () => rows.filter((row) => !row.hidden);

    const reflect = () => {
      rows.forEach((row) => {
        const playing = row === current && !player.paused;
        row.classList.toggle('is-current', row === current);
        const button = $('.playlist-play', row);
        if (button) {
          button.textContent = playing ? '❚❚' : '▶';
          button.setAttribute('aria-label', (playing ? 'Mettre en pause : ' : 'Lire : ') + titleOf(row));
        }
      });
    };

    const announce = (message) => {
      if (status) status.textContent = message;
    };

    const setTrack = (row, play) => {
      if (!row) return;
      current = row;
      player.src = row.dataset.src;
      player.load();
      announce('En cours : ' + titleOf(row));
      reflect();
      if (play) {
        const pending = player.play();
        if (pending && pending.catch) {
          pending.catch(() => announce('Lecture bloquée par le navigateur : utilisez le bouton du lecteur.'));
        }
      }
    };

    const step = (offset) => {
      const shown = visible();
      if (!shown.length) return;
      const index = shown.indexOf(current);
      const next = index < 0 ? 0 : (index + offset + shown.length) % shown.length;
      setTrack(shown[next], true);
    };

    const applyFilters = () => {
      const author = select ? select.value : '';
      const query = search ? search.value.trim().toLowerCase() : '';
      let shown = 0;
      rows.forEach((row) => {
        const authorOk = !author || row.dataset.author === author;
        const textOk = !query || (row.dataset.search || '').includes(query);
        row.hidden = !(authorOk && textOk);
        if (!row.hidden) shown++;
      });
      if (count) {
        count.textContent = shown + ' enregistrement' + (shown > 1 ? 's' : '');
      }
      if (current && current.hidden) {
        current = null;
        player.pause();
        player.removeAttribute('src');
        player.load();
        announce('Choisissez une question-réponse pour commencer l’écoute.');
      }
      reflect();
    };

    rows.forEach((row) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => setTrack(row, true));
    });
    const previous = $('[data-fatwa-prev]');
    const next = $('[data-fatwa-next]');
    if (previous) previous.addEventListener('click', () => step(-1));
    if (next) next.addEventListener('click', () => step(1));
    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => step(1));

    if (select) {
      const requested = new URLSearchParams(window.location.search).get('auteur');
      if (requested && rows.some((row) => row.dataset.author === requested)) {
        select.value = requested;
      }
      select.addEventListener('change', applyFilters);
    }
    if (search) {
      search.addEventListener('input', applyFilters);
      search.addEventListener('search', applyFilters);
    }
    applyFilters();
  }

  document.addEventListener('DOMContentLoaded', () => {
    initMenu();
    initNotifyForm();
    initLibrary();
    initAudioPlaylist();
    initRajazPlaylist();
    initFatwaPlaylist();
    initGlobalSearch();
    initMourideNav();
    initConferenceMenu();
    initMourideGallery();
    initToTop();
  });
})();

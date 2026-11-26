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

  document.addEventListener('DOMContentLoaded', () => {
    initMenu();
    initNotifyForm();
    initLibrary();
    initToTop();
  });
})();

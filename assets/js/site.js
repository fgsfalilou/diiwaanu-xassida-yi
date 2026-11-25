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

    const state = { query: '', lang: 'Toutes', letter: 'Toutes' };

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
      let visible = 0;

      rows.forEach((row) => {
        const title = normalise(row.dataset.title);
        const lang = row.dataset.lang || '';
        const letter = (row.dataset.letter || '#').toUpperCase();
        const matchesQuery = !query || title.includes(query);
        const matchesLang = state.lang === 'Toutes' || lang === state.lang;
        const matchesLetter = state.letter === 'Toutes' || letter === state.letter;
        const show = matchesQuery && matchesLang && matchesLetter;
        row.hidden = !show;
        if (show) visible += 1;
      });

      count.textContent = `${visible} khassaïde${visible > 1 ? 's' : ''} affichée${visible > 1 ? 's' : ''}`;
    };

    search.addEventListener('input', (event) => {
      state.query = event.target.value.trim();
      apply();
    });

    $$('[data-lang]').forEach((button) => {
      button.addEventListener('click', () => {
        state.lang = button.dataset.lang;
        $$('[data-lang]').forEach((other) => {
          other.setAttribute('aria-pressed', String(other === button));
        });
        apply();
      });
    });

    if (alpha) {
      alpha.addEventListener('click', (event) => {
        const button = event.target.closest('[data-letter]');
        if (!button) return;
        state.letter = button.dataset.letter;
        $$('[data-letter]', alpha).forEach((other) => {
          other.setAttribute('aria-pressed', String(other === button));
        });
        apply();
      });
    }

    apply();
  }

  document.addEventListener('DOMContentLoaded', () => {
    initMenu();
    initNotifyForm();
    initLibrary();
  });
})();

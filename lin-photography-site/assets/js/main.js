(function () {
  "use strict";

  var CONTACT_EMAIL = "qilin375hptak@outlook.jp";
  var INTRO_LOCK_MS = 5600;

  /* ---------- Mobile menu toggle ---------- */
  var siteHeader = document.getElementById("site-header");
  var menuToggle = document.getElementById("menu-toggle");
  var siteNav = document.getElementById("site-nav");

  if (menuToggle && siteHeader) {
    menuToggle.addEventListener("click", function () {
      siteHeader.classList.toggle("nav-open");
    });
  }

  if (siteNav && siteHeader) {
    siteNav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        siteHeader.classList.remove("nav-open");
      });
    });
  }

  /* ---------- Lock scroll on first load so only the hero shows ---------- */
  var hero = document.getElementById("home");
  if (hero) {
    document.documentElement.classList.add("lock-scroll");
    document.body.classList.add("lock-scroll");

    setTimeout(function () {
      document.documentElement.classList.remove("lock-scroll");
      document.body.classList.remove("lock-scroll");
      var cue = document.getElementById("scroll-cue");
      if (cue) cue.classList.add("show");
      if (siteHeader) siteHeader.classList.add("show");
    }, INTRO_LOCK_MS);
  }

  /* ---------- Hero logo overlay ---------- */
  window.addEventListener("load", function () {
    var logo = document.getElementById("hero-logo");
    if (!logo) return;
    requestAnimationFrame(function () {
      logo.classList.add("show");
    });
    setTimeout(function () {
      logo.classList.remove("show");
      logo.classList.add("hide");
    }, 3600);
  });

  /* ---------- Hero slideshows (top / bottom strips) ---------- */
  function runSlideshow(scopeSelector, startDelay) {
    var slides = document.querySelectorAll(scopeSelector + " .slide");
    if (slides.length < 2) return;
    var current = 0;
    setTimeout(function () {
      setInterval(function () {
        slides[current].classList.remove("active");
        current = (current + 1) % slides.length;
        slides[current].classList.add("active");
      }, 7000);
    }, startDelay);
  }

  runSlideshow(".hero-split-top", 0);
  runSlideshow(".hero-split-bottom", 3500);

  /* ---------- Language switching ---------- */
  function applyLanguage(lang) {
    var dict = window.I18N[lang] || window.I18N.ja;

    document.querySelectorAll("[data-i18n]").forEach(function (el) {
      var key = el.getAttribute("data-i18n");
      if (dict[key] !== undefined) el.innerHTML = dict[key];
    });

    document.querySelectorAll("[data-i18n-placeholder]").forEach(function (el) {
      var key = el.getAttribute("data-i18n-placeholder");
      if (dict[key] !== undefined) el.setAttribute("placeholder", dict[key]);
    });

    document.querySelectorAll(".lang-switch button").forEach(function (btn) {
      btn.classList.toggle("active", btn.getAttribute("data-lang") === lang);
    });

    document.documentElement.setAttribute("lang", lang);
    try { localStorage.setItem("lin-site-lang", lang); } catch (e) {}
  }

  document.querySelectorAll(".lang-switch button").forEach(function (btn) {
    btn.addEventListener("click", function () {
      applyLanguage(btn.getAttribute("data-lang"));
    });
  });

  var savedLang = "ja";
  try { savedLang = localStorage.getItem("lin-site-lang") || "ja"; } catch (e) {}
  applyLanguage(savedLang);

  /* ---------- Contact form -> mailto ---------- */
  var form = document.getElementById("contact-form");
  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      var name = form.elements["name"].value.trim();
      var email = form.elements["email"].value.trim();
      var message = form.elements["message"].value.trim();

      var subject = "[Website] Inquiry from " + name;
      var body =
        "Name: " + name + "\n" +
        "Email: " + email + "\n\n" +
        message;

      var mailto =
        "mailto:" + CONTACT_EMAIL +
        "?subject=" + encodeURIComponent(subject) +
        "&body=" + encodeURIComponent(body);

      window.location.href = mailto;
    });
  }

  /* ---------- WeChat QR modal ---------- */
  var qrModal = document.getElementById("qr-modal");
  var wechatBtn = document.getElementById("wechat-btn");
  var qrClose = document.getElementById("qr-modal-close");
  var qrBackdrop = document.getElementById("qr-modal-backdrop");

  function openQrModal() { qrModal.classList.add("open"); }
  function closeQrModal() { qrModal.classList.remove("open"); }

  if (wechatBtn) wechatBtn.addEventListener("click", openQrModal);
  if (qrClose) qrClose.addEventListener("click", closeQrModal);
  if (qrBackdrop) qrBackdrop.addEventListener("click", closeQrModal);
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeQrModal();
  });

  document.querySelectorAll(".contact-email-target").forEach(function (el) {
    el.textContent = CONTACT_EMAIL;
    if (el.tagName === "A") el.href = "mailto:" + CONTACT_EMAIL;
  });
})();

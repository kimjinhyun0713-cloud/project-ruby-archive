// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

// app/javascript/application.js

document.addEventListener("turbo:load", () => {
  // 1. "js-scroll-anchor" クラスがついたリンクを全て監視
  const links = document.querySelectorAll('.js-scroll-anchor');

  links.forEach((link) => {
    link.addEventListener('click', (e) => {
      // 一旦デフォルトの動き（ジャンプ）を止める
      e.preventDefault();

      // href="#anchor-12" から "12" という数字だけ取り出す
      const href = link.getAttribute('href'); // "#anchor-12"
      const targetNum = href.split('-')[1];   // "12"
      
      console.log("Target Number:", targetNum); // 確認用ログ

      // 2. 飛び先を探す（[12] というテキストを持っている span を探す）
      const targets = document.querySelectorAll('.text-anchor-target');
      let targetElement = null;

      targets.forEach((span) => {
        // spanの中身が "[12]" を含んでいれば当たり
        if (span.innerText.includes(`[${targetNum}]`)) {
          targetElement = span;
        }
      });

      // 3. 見つかったらスクロール
      if (targetElement) {
        // スムーズに移動
        targetElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        
        // ハイライト演出（オプション：わかりやすく一瞬色を変える）
        targetElement.style.transition = "background-color 0.5s";
        targetElement.style.backgroundColor = "yellow";
        setTimeout(() => {
          targetElement.style.backgroundColor = "#fff0f0"; // 元の色に戻す
        }, 1500);

        // URLを更新する（#anchor-12 をつける）
        history.pushState(null, null, href);
      } else {
        console.warn("飛び先が見つかりませんでした: [", targetNum, "]");
      }
    });
  });
});
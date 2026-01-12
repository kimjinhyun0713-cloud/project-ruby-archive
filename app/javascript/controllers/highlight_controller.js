import { Controller } from "@hotwired/stimulus"
import hljs from "highlight.js"

// 必要な言語だけを読み込むことで軽量化できます（下記は一例）
// import ruby from "highlight.js/lib/languages/ruby"
// hljs.registerLanguage('ruby', ruby);

export default class extends Controller {
  connect() {
    // ページ読み込み時と、Turboによる遷移時に実行
    this.highlight()
  }

  highlight() {
    // .trix-content 内の pre タグ（コードブロック）を全て取得
    this.element.querySelectorAll("pre").forEach((block) => {
      // 既にハイライト済みでなければ適用
      if (!block.dataset.highlighted) {
        hljs.highlightElement(block);
        block.dataset.highlighted = "yes"; // 二重適用防止
      }
    });
  }
}

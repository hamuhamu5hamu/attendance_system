document.addEventListener("DOMContentLoaded", function () {
    const tabs = document.querySelectorAll(".tabs a");
    const panels = document.querySelectorAll(".tab-panel");
  
    tabs.forEach((tab) => {
      tab.addEventListener("click", (e) => {
        e.preventDefault();
  
        // すべてのタブとパネルから"active"クラスを削除
        tabs.forEach((t) => t.classList.remove("active"));
        panels.forEach((panel) => panel.classList.remove("active"));
  
        // クリックしたタブと対応するパネルに"active"クラスを追加
        tab.classList.add("active");
        const panelId = tab.getAttribute("data-tab");
        document.getElementById(panelId).classList.add("active");
      });
    });
  });
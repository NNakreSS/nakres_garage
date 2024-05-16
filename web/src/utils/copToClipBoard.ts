export default function copyTextToClipboard(text: string) {
  // Metni panoya kopyalamak için bir textarea elementi oluşturuyoruz
  var textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.style.position = "fixed"; // textarea'yı ekranın dışına yerleştiriyoruz
  document.body.appendChild(textarea);

  // Metni seçiyoruz ve kopyalıyoruz
  textarea.select();
  document.execCommand("copy");

  // Kullandıktan sonra textarea'yı kaldırıyoruz
  document.body.removeChild(textarea);
}

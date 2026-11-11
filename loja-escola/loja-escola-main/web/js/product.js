const params = new URLSearchParams(window.location.search);
const produto = buscarProduto(params.get("id"));

const conteudo = document.querySelector("#produtoConteudo");
const naoEncontrado = document.querySelector("#produtoNaoEncontrado");
const formProduto = document.querySelector("#formProduto");
const quantidade = document.querySelector("#quantidade");
const feedback = document.querySelector("#produtoFeedback");

function definirMeta(seletor, valor) {
  document.querySelector(seletor)?.setAttribute("content", valor);
}

function mostrarProduto(p) {
  document.title = `${p.nome} | Loja da Scarlet`;
  definirMeta('meta[name="description"]', `${p.nome}: ${p.resumo} ${formatarPreco(p.preco)} no Loja da Scarlet.`);
  definirMeta('meta[property="og:title"]', `${p.nome} | Loja da Scarlet`);
  definirMeta('meta[property="og:description"]', p.resumo);

  document.querySelector("#breadcrumbProduto").textContent = p.nome;
  const imagem = document.querySelector("#produtoImagem");
  imagem.src = p.imagem;
  imagem.alt = p.alt;
  document.querySelector("#produtoCategoria").textContent = p.categoria;
  document.querySelector("#produtoNome").textContent = p.nome;
  document.querySelector("#produtoResumo").textContent = p.resumo;
  document.querySelector("#produtoPreco").textContent = formatarPreco(p.preco);
  document.querySelector("#produtoDescricao").textContent = p.descricao;

  document.querySelector("#produtoRegras").replaceChildren(
    ...p.regras.map((r) => Object.assign(document.createElement("li"), { className: "badge-regra", textContent: REGRAS[r] }))
  );
  document.querySelector("#produtoInfo").replaceChildren(
    ...Object.entries(p.info).flatMap(([titulo, valor]) => [
      Object.assign(document.createElement("dt"), { textContent: titulo }),
      Object.assign(document.createElement("dd"), { textContent: valor }),
    ])
  );
  quantidade.max = QTD_MAX;
  conteudo.hidden = false;
}

function mostrarErro(mensagem) {
  feedback.className = "mt-3 feedback feedback-erro";
  feedback.textContent = mensagem;
}

if (produto) {
  mostrarProduto(produto);
} else {
  document.title = "Produto não encontrado | Loja da Scarlet";
  naoEncontrado.hidden = false;
}

formProduto?.addEventListener("submit", (event) => {
  event.preventDefault();
  const qtd = Number(quantidade.value);

  if (!Number.isInteger(qtd) || qtd < QTD_MIN || qtd > QTD_MAX) {
    quantidade.setAttribute("aria-invalid", "true");
    mostrarErro(`Escolha uma quantidade inteira entre ${QTD_MIN} e ${QTD_MAX}.`);
    quantidade.focus();
    return;
  }
  quantidade.removeAttribute("aria-invalid");

  adicionarAoCarrinho(produto.id, qtd);

  // event.submitter é o botão que disparou o envio
  if (event.submitter?.value === "comprar") {
    window.location.href = "checkout.html";
    return;
  }
  feedback.className = "mt-3 feedback feedback-ok";
  feedback.textContent = `${qtd} × ${produto.nome} adicionado ao carrinho.`;
});

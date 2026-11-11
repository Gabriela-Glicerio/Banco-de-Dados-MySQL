const concluido = document.querySelector("#pedidoConcluido");
const semPedido = document.querySelector("#semPedido");

function lerPedido() {
  try {
    const pedido = JSON.parse(sessionStorage.getItem("pedido"));
    return pedido && pedido.numero && Array.isArray(pedido.itens) ? pedido : null;
  } catch {
    return null;
  }
}

const pedido = lerPedido();

if (!pedido) {
  // acesso direto, sem compra concluída
  document.title = "Nenhuma compra encontrada | Loja da Scarlet";
  semPedido.hidden = false;
} else {
  document.querySelector("#mensagemCliente").textContent =
    `${pedido.nome}, recebemos o seu pedido. Ele ainda não existe no mundo real, mas já existe aqui.`;
  document.querySelector("#numeroPedido").textContent = pedido.numero;
  document.querySelector("#formaPagamento").textContent = pedido.pagamento;
  document.querySelector("#itensPedido").replaceChildren(
    ...pedido.itens.map((item) =>
      Object.assign(document.createElement("li"), {
        textContent: `${item.qtd} × ${item.nome} — ${formatarPreco(item.preco * item.qtd)}`,
      })
    )
  );
  document.querySelector("#valorSubtotal").textContent = formatarPreco(pedido.subtotal);
  document.querySelector("#valorFrete").textContent = pedido.frete === 0 ? "Grátis" : formatarPreco(pedido.frete);
  document.querySelector("#valorTotal").textContent = formatarPreco(pedido.total);
  concluido.hidden = false;
}

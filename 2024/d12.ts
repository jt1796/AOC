import "./common.js";

const grid = "d12.txt".readStringGrid();

const symbols = grid.gridSymbolMap();

Object.keys(symbols).forEach((symbol) => {
    const area = symbols[symbol].length;
    const perimeter = symbols[symbol]
        .flatMap(coords => grid.gridNeighbors(coords))
        .filter(sym => sym !== symbol)
        .length;

    console.log({ symbol, area, perimeter });
});

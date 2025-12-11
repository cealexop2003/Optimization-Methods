function val = f_xy(x, y)
    val = x.^3 .* exp(-x.^2 - y.^4);
end

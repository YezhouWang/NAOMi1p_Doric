function A = array_SubModTest_matlab(A, idx_mod, mod_val, sc)

    assert(isa(A, 'single'));
    assert(isa(idx_mod, 'int32'));
    assert(isa(mod_val, 'single'));

    if isempty(idx_mod)
        return;
    end

    if any(idx_mod < 1) || any(idx_mod > numel(A))
        error('idx_mod out of bounds');
    end

    if numel(idx_mod) ~= numel(mod_val)
        error('idx_mod and mod_val size mismatch');
    end

    A(idx_mod) = A(idx_mod) + mod_val .* sc;
end

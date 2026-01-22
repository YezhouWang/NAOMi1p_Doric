function A = array_SubSubTest_matlab(A, idx_mod, mod_val, sc)
% MATLAB replacement for array_SubSubTest MEX
% Performs: A(idx_mod) = mod_val .* sc
%
% Inputs:
%   A        : single array (volume)
%   idx_mod  : int32 linear indices (1-based)
%   mod_val  : single values (same length as idx_mod)
%   sc       : scalar multiplier (single or double)

    % ---- quick exit ----
    if isempty(idx_mod)
        return
    end

    % ---- minimal safety checks (cheap) ----
    if ~isa(A, 'single')
        error('array_SubSubTest_matlab: A must be single');
    end
    if ~isa(idx_mod, 'int32')
        error('array_SubSubTest_matlab: idx_mod must be int32');
    end
    if ~isa(mod_val, 'single')
        error('array_SubSubTest_matlab: mod_val must be single');
    end
    if numel(idx_mod) ~= numel(mod_val)
        error('array_SubSubTest_matlab: idx_mod and mod_val size mismatch');
    end

    % ---- bounds check (critical for NAOMi safety) ----
    if any(idx_mod < 1) || any(idx_mod > numel(A))
        error('array_SubSubTest_matlab: idx_mod out of bounds');
    end

    % ---- core operation ----
    A(idx_mod) = mod_val .* sc;
end
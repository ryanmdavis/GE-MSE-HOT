function mask = getMask(obj,varargin)
    invar = struct('sampling_factor',1);
    argin = varargin;
    invar = generateArgin(invar,argin);
    mask = imresize(obj.mask,invar.sampling_factor);
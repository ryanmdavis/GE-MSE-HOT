function varargout = reconGeHotSpectra(path,varargin)

invar = struct('recon_elem',0);
argin = varargin;
invar = generateArgin(invar,argin);

raw = readGE2DRaw(path);
spectra = fftshift(fftshift(fft(fft(fftshift(fftshift(raw,4),5),[],4),[],5),4),5);

if invar.recon_elem == 0
    recon_elem = 1:size(raw,2);
else 
    recon_elem = invar.recon_elem;
end

fields = struct('Coil_name',[],'sequence_number',[],'yres',[],'variable_46',[],'variable_47',[]);
fields = getGeHdrEntry(strcat(path,'_header.txt'),fields);

display(strcat('scan number: ',num2str(fields.sequence_number)));

%assemble phased array data if is a coil array:
if coilName2NumCoils(fields.Coil_name) > 1
%     spectra=sum(abs(spectra(:,recon_elem,:,:,:)),2);
%     spectra=spectra(:,1,:,:,:);
    warning('not summing coil elements');
end

upsample_factor = 2;
spectra = upsampleImage(spectra,upsample_factor);
% spectra = permute(artificialFourierUpsample(permute(squeeze(spectra),[1 4 2 3]),upsample_factor),[1 3 4 2]);

varargout{1}=spectra;
if nargout >= 2
    varargout{2} = fields;
end
if nargout >= 3
    varargout{3} = raw;
end
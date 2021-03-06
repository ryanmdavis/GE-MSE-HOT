%1)Make ROI
%2) press d to delete
%3) press space (or anything else) to keep
%4) press f to finish
%5) get(hFig,'CurrentCharacter')
function obj = getRoisFromUser(obj,argin)
invar = struct('window',0);
invar = generateArgin(invar,argin);
if size(argin,2) == 2
    image = argin{1};
    h_instructions = argin{2};
elseif (size(argin,2) == 1) || (size(argin,2) == 3)
    image = argin{1};
    h_instructions = 0;
else
    error('Improper number of arguments to RoiList')
end
roi_count = 1;

if invar.window == 0
    hFig = imagesc(image);
else
    hFig = imagesc(image,invar.window);
end

axis image;
axis off;
key_pressed = 'd';
instructions = 'Keep ROI? d - delete current ROI  click - keep current ROI  f - keep current ROI and finish';

    while ~(key_pressed == 'f')
        key_pressed = 'd';
        while (key_pressed == 'd')
            new_ROI = Roi(image,obj,'window',invar.window,'input_type','point and click');
            
            if invar.window == 0
                hFig = imagesc(image);
            else
                hFig = imagesc(image,invar.window);
            end
            
            axis image
            axis off
            color = getObjColor(obj.getLength() + 1);
            [xi,yi] = new_ROI.getRoiPoints;
            patch(xi,yi,color);
            obj.patchRois;

            if h_instructions ~= 0
                set(h_instructions,'string',instructions)
            else
                title(instructions);
            end
            
            button_press = waitforbuttonpress;
            key_pressed = get(gcf,'CurrentCharacter');
            if button_press == 1
                while ~((key_pressed == 'f') || (key_pressed =='d'))
                    button_press = waitforbuttonpress;
                    key_pressed = get(gcf,'CurrentCharacter');
                end
            else
                key_pressed = 'n';  %no button pressed
            end
%             key_pressed = get(gcf,'CurrentCharacter');
        end
        obj.length = obj.length + 1;
        obj = obj.addRoi(new_ROI);
        obj.patchRois;
    end

    
    
%1)Make ROI
%2) press d to delete
%3) press space (or anything else) to keep
%4) press f to finish
%5) get(hFig,'CurrentCharacter')
function LIST = getRoisFromUser(image,instructions)
roi_count = 1;
hFig = imagesc(image);
title(instructions);
LIST = RoiList();
key_pressed = 'd';

    while ~(key_pressed == 'f')
        key_pressed = 'd';
        while (key_pressed == 'd')
            new_ROI = Roi(image,LIST);
            
            hFig = imagesc(image);
            color = getObjColor(LIST.getLength() + 1);
            [xi,yi] = new_ROI.getRoiPoints;
            patch(xi,yi,color);
            LIST.patchRois;
            
            title('Keep ROI? d - delete current ROI  click - keep current ROI  f - keep durrent ROI and finish');
            
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
        LIST = LIST.addRoi(new_ROI);
        LIST.patchRois;
    end
    
pause(.5)

    
    
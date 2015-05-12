function clickDoneCallback(src,eventData,click_callback_ID)
if strcmp(get(gcf,'SelectionType'),'extend')
    iptremovecallback(gcf,'WindowButtonMotionFcn',click_callback_ID);
end
function isbel=IsBelievable(img_c,pro_f,pro_b,allpixnum)
%����ֵ���ж���ǰ֡�Ƿ����

errth=0.1;

error1=sum(sum(xor(pro_f,img_c)));
error2=sum(sum(xor(pro_b,img_c)));
errpixnum=(error1+error2)/2;
errpro=errpixnum/allpixnum;
if errpro<errth
    isbel=1;
else
    isbel=0;
end

end


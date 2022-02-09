clear
load('OptionData.mat')
temp=[];kk=0;
for i=2:1069
    k=OptionData{i,4};
    for M=2:3
        if M==3
          data=OptionData{i,3}; 
        else
          data=OptionData{i,2};
        end      
        a=unique(cell2mat(data(2:end,5)));
        for g=1:length(a)
            if a(g)>=5
                t=a(g);
                break
            end
        end
        for q1=2:size(data,1)
            s=data{q1,3};
            x=abs(s-k);
            if k<=3
                sk=0.025;
            else
                sk=0.05;
            end                
            if x<=sk && data{q1,5}==t
                L1=q1;    
                break
            end
        end 
        for q2=2:size(data,1)
            if data{q2,5}==t&&data{q2+1,5}~=t
            L2=q2;
            end
        end
        if M==3
            for q2=size(data,1):-1:3
                if data{q2,5}==t && data{q2-1,5}~=t
                    L2=q2;
                    break
                end
                if q2==3
                    L2=2;
                end
            end
        else
            for q2=2:size(data,1)
                if data{q2,5}==t&&data{q2+1,5}~=t
                    L2=q2;
                    break
                end
            end
        end
        if M==3
            for h=L1:-1:L2+1
                for j=h-1:-1:L2
                    x=abs(data{h,12}-data{j,12});
                    if ~isnan(x)
                        kk=kk+1;
                        temp(kk,1)=x;
                    end
                end
            end
        else
            for h=L1:L2-1
                for j=h+1:L2
                    x=abs(data{h,12}-data{j,12});
                    if ~isnan(x)
                        kk=kk+1;
                        temp(kk,1)=x;
                    end
                end
            end
        end
    end
end


T=sort(temp);
histogram(T);
AVG=mean(T);
Z=mode(T);
p50=prctile(T,50);
p60=prctile(T,60);
p70=prctile(T,70);
p80=prctile(T,80);
p90=prctile(T,90);
s=std(T);
table(AVG,Z,s,p50,p60,p70,p80,p90)
count()





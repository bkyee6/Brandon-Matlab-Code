% title(['jello ' num2str(i) ''])
%difference color scale purple orange
%file = 'JelloDay2-17.mat';
file = 'SalineDay3-3';
load(strcat(file,'.mat'))

%start = 501329; %Phantom 1  current voltage
%start = 489098; %Phantom 1
%start = 513560; %Phantom 1

%start = 147764; %Phantom 2 constant current
%start = 159995; %Phantom 2
%start = 172226; %Phantom 2

start = 26120; %Saline 3-3
%start = 54496; %Saline 3-2
%start = 403896; %Saline 3-1

%F(5) = struct('cdata',[],'colormap',[]);
d1 = zeros(48,10);

for i = 1:1
    for j = 1:48
        d1(j,i) = Wave.data(start + i,j);
    end
    
    d2 = zeros(6,8);
    for j = 1:6
        for k = 1:8
            d2(j,k) = d1( ((j - 1) * 8) + k,i);
        end
    end
   
    A1 = theoryCalc48(28,36,0.001,1.5);
    A2 = zeros(6,8);
    for j = 1:6
        for k = 1:8
            A2(j,k) = A1( ((j - 1) * 8) + k,1);
        end
    end

    %d2(5,4) = NaN;
    %d2(5,5) = NaN;
    A2(4,4) = 0;
    A2(5,4) = 0;
    
    fontSize = 36;
    cmin = -2.5*10e-3;
    cmax = 2.5*10e-3;
    size = 201;
    map = zeros(size,3);
    for k = 1:size
        if k > size/2
            map(k,1) = 1;
            map(k,2) = (size - k) * 0.01;
            map(k,3) = (size - k) * 0.01;
        else
            map(k,1) = (k - 1) * 0.01;
            map(k,2) = (k - 1) * 0.01;
            map(k,3) = 1;
        end
    end
    color = map;
    
    d1(28,1) = NaN;
    d1(36,1) = NaN;

    figure;
    hold on
    plot(1:48,d1(:,i),'b', 'Marker','o','LineStyle','--');
    plot(1:48,A1,'r','Marker','o','LineStyle','--');
    xlabel('Electrode Number','FontSize', fontSize)
    ylabel('Voltage','FontSize', fontSize)
    title(['Voltage vs Electrode Number for Theoretical and Phantom Brain Models'],'FontSize', fontSize)
    JT_legend = legend('Jello Voltage Data','Theoretical Voltage Data');
    set(JT_legend,'FontSize', fontSize);

    %
    
    figure;
    imagesc(A2);
    colormap(color);
    c = colorbar;
    ylabel(c,'Voltage (V)','FontSize', fontSize)
    caxis([cmin cmax]);
    xlabel('X-electrode','FontSize', fontSize)
    ylabel('Y-electrode','FontSize', fontSize)
    title('Theoretical Voltages at Discrete Electrodes','FontSize', fontSize)
    pbaspect([8 6 1]);
    figure;
    imagesc(d2);
    colormap(color);
    c = colorbar;
    ylabel(c,'Voltage (V)','FontSize', fontSize)
    caxis([cmin cmax]);
    xlabel('X-electrode','FontSize', fontSize)
    ylabel('Y-electrode','FontSize', fontSize)
    title(['Phantom Brain Model Voltages at Discrete Electrodes'],'FontSize', fontSize)
    pbaspect([8 6 1]);
    
    diff = zeros(48,1);
    for i = 1:48
        diff(i,1) = (d1(i,1) - A1(i,1));
    end
    
    figure;
    histogram(diff,8);
    title('Voltage Difference Between Phantom and Theory','FontSize', 20);
    xlabel('Voltage difference (V)','FontSize', 20);
    %xlim([-6e-3 2e-3]);
    ylabel('Count of electrodes','FontSize', 20);
    %{
    figure;
    imagesc(d2-A2);
    colormap(color);
    c = colorbar;
    ylabel(c,'Voltage (V)','FontSize', fontSize)
    caxis([cmin cmax]);
    xlabel('X-electrode','FontSize', fontSize)
    ylabel('Y-electrode','FontSize', fontSize)
    title([file ' - Theoretical Voltage Difference'],'FontSize', fontSize)
    
    figure;
    caxis([cmin cmax]);
    bar3(A2);
    colormap(color);
    title(i,'FontSize', fontSize);
    axis([0 9 0 7 -0.01 0.01]);
    %F(i) = getframe(gcf);
    %}
        
    [X,Y] = meshgrid(0:0.01:9,0:0.01:6);
    r1 = sqrt((Y - 2).^2 + (X - 6).^2);
    r2 = sqrt((Y - 3).^2 + (X - 6).^2);
    Z = ( 1.75e-3  ./ (2*pi) ) * ( 100./r2 - 100./r1);
    
    res = zeros(48,3);
    count = 1;
    for i = 1:8
        for j = 1:6
            res(count,1) = i;
            res(count,2) = 6-j;
            res(count,3) = david2(j,i);
            count = count + 1;
        end
    end
    height = zeros(48,1) + 5;
    
    figure;
    hold on;
    surface(X,Y,Z,'EdgeColor','none');
    scatter3(res(:,1), res(:,2), height, 700, res(:,3), 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 2)
    
    colormap(color);
    c = colorbar;
    caxis([cmin cmax]);
    xlabel('X-electrode Number','FontSize', fontSize)
    ylabel('Y-electrode Number','FontSize', fontSize)
    ylabel(c,'Recorded Voltage (V)','FontSize', fontSize)
    title({'Comparing Recorded Peak ECoG Voltages','and Theoretical Voltages'} ,'FontSize', fontSize)
    pbaspect([1 1 1]);
    axis([0 9 0 6]);
    
end
%fig = figure;
%movie(fig, F, 1, 1)

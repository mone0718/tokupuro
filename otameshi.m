x_finger = [1,2,5,7,8,9,10,13];
x_palm = [0.5,1,2,3,4,5,7,11];


y1 = [0,50,100,100,100,100,100,100];

%plot(x_palm,y1,'gs');
%title('finger Fujita');


y2= [0,0,10,40,90,90,100,100];

%plot(x_finger,y2,'bs');
%title('palm Fujita')

plot(x_palm,y1,'r.',x_finger,y2,'b.','MarkerSize',20);
title('Fujita palm & finger');


y3 = [60,50,100,100,100,100,100,100];

%plot(x_finger,y3,'bs');
%title('finger Yokoyama');


y4 = [10,20,30,60,80,80,100,100];

%plot(x_palm,y4,'bs');
%title('palm Yokoyama');


y5 = [20,20,70,100,100,100,100,100];

%plot(x_finger,y5,'bs');
%title('finger Naito');


y6 = [40,40,40,50,50,50,80,100];

%plot(x_palm,y6,'bs');
%title('palm Naito');


y7 = [10,40,80,100,100,100,100,100];

%plot(x_finger,y7,'bs');
%title('finger Egashira');


y8 = [20,0,20,40,60,90,90,100];

%plot(x_palm,y8,'bs');
%title('palm Egashira');


y9 = [0,0,40,80,100,100,100,100];

%plot(x_finger,y9,'bs');
%title('finger Sakaguchi');


y10 = [10,10,20,20,50,90,100,100];

%plot(x_palm,y10,'bs');
%title('palm Egashira');

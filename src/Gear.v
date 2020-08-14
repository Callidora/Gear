module Gear(clk,rst,pwm,ctr);
//input signal;
input clk;
input rst;
//output signal;
output pwm;
output ctr;

reg pwm;
reg ctr;

//Change the clock;
integer clk_cnt;
reg clk_10KHz;//System frequency ~ 24MHz,10KHz ~ clk_cnt=2400
always @(posedge clk)
begin
	if(clk_cnt==2400)
			begin clk_cnt<=1'b0;  clk_10KHz=~clk_10KHz;  end
	else    begin clk_cnt<=clk_cnt+1'b1; end
end

reg [7:0]counter;//计数，产生不同脉冲
reg [7:0]counter1;//计数，人类心跳为60-100次/min，因此约0.5s一次
integer freq;

always @(posedge clk_10KHz or negedge rst)
begin
	if(!rst)	//初始化计数器
		begin
			counter<=0;
			counter1<=0;
			pwm<=1;
			ctr<=1;
		
		end      
	else        //实际开始运行程序
		begin
			if(counter1<=8'd25)begin
				if(freq<=8'd5)begin 
					pwm<=1;
					ctr<=1;
					freq<=freq+1; 
				end   //产生0.5ms的脉冲
		    	else if(freq<=8'd200)begin  
		    		pwm<=0; 
		    		ctr<=0;
		    		freq<=freq+1; 
		    	end 
		    	else begin  
		    		freq<=0;
		    		counter1<=counter1+1; 
		    	end
		    end
		    else if(counter1<=8'd50)begin
		    		if(freq<=8'd15)begin 
						pwm<=1;
						ctr<=1;
						freq<=freq+1; 
					end   //产生1.5ms的脉冲
		    		else if(freq<=8'd200)begin  
		    			pwm<=0; 
		    			ctr<=0;
		    			freq<=freq+1; 
		    		end 
		    		else begin  
		    			freq<=0;
		    			counter1<=counter1+1; 
		    		end
		    end
		    else begin 
		    counter1<=0;
		    end
		end
end
endmodule
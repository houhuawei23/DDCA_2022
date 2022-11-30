/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :key_function.v  
** CreateDate :2015.03
** Funtions   :按键的一些作用：1、按下一次有效。2、按下连续有效。3、按下无效，松开有效。默认按键已经消抖。
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
module  key_function (
           clk,
           rst_n,
           
                     key_1,
                     key_2,
                     key_3,
                     
                     led_1,
                     led_2,
                     led_3
             );
 input          clk;            //24M
 input          rst_n;
 input          key_1;          //按键1，按下一次有效
 input          key_2;          //按键2、按下连续有效
 input          key_3;          //按键3、按下无效释放有效
 
 output         led_1;          //按键1有效时，翻转
 output         led_2;          //按键1有效时，翻转 
 output         led_3;          //按键1有效时，翻转
 
 //------------------------------
 //分频到4hz(250ms)，使下载到板子的现象明显
 wire        clk_4hz;
 localparam  cntt_4hz = 23'd5999999;         //实际设计
// localparam  cntt_4hz = 23'd599;               //仿真测试用
 reg      [22:0]      cnt;
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
      cnt <= 0;
    end
  else  if(!key_2)
    begin
      if(cnt == cntt_4hz)
               cnt <= 0;
            else 
                cnt <= cnt + 1;
    end
    else 
        cnt <= 0; 
  end
    
assign  clk_4hz = (cnt == cntt_4hz);         //4HZ的时钟，只有一个clk的时间

//----------key1----------------
reg     [2:0]    key_1_reg;
wire             key_1_neg;
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
       key_1_reg <= 3'b111;                //默认按键没有按下时为高电平
    end
  else 
    begin
        key_1_reg  <= {key_1_reg[1:0],key_1};
    end
  end

assign key_1_neg = key_1_reg[2]&(~key_1_reg[1]);

reg      led_d1;
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
      led_d1 <= 0;
    end
  else if(key_1_neg)
    begin
      led_d1 <= ~led_d1; 
    end
    else 
          led_d1 <= led_d1;     
  end
//--------------key2--------------
 reg             led_d2;
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
     led_d2  <= 0;
    end
  else if(!key_2)               //按键按下后
    begin
     if(clk_4hz)                //4hz时钟高电平来的时候
            led_d2  <= ~led_d2;
          else 
                led_d2  <= led_d2;    
    end
  end
    
//--------------key3--------------
reg    [2:0]     key_3_reg;
wire             key_3_pos;
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
       key_3_reg <= 3'b111;                //默认按键没有按下时为高电平
    end
  else 
    begin
        key_3_reg  <= {key_3_reg[1:0],key_3};
    end
  end

assign key_3_pos = ~key_3_reg[2]&key_3_reg[1];

reg      led_d3;
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
      led_d3 <= 0;
    end
  else if(key_3_pos)
    begin
      led_d3 <= ~led_d3; 
    end
    else 
          led_d3 <= led_d3;     
  end

    
//---------------------
assign led_1 = led_d1;
assign led_2 = led_d2;
assign led_3 = led_d3;

endmodule
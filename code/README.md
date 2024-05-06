# 實作注意事項

1. 盡量不要使用for迴圈，以clk作為觸發時機，進行資料的讀取與寫入。
2. 2 cycle的乘法器，並不是2個cycle就可以完成**整個OutPut Feature Map**，而是2個cycle完成**一個Output Pixel**。(第一個做乘法，第二個cycle做加法)，如果output feature map的size是6x6，那麼乘法器完成的cycle數應該是第6x6x2=72個cycle。
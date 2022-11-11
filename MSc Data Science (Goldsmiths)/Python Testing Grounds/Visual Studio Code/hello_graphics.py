#%%
import graphics

def main():
    win = graphics.GraphWin("My Circle", 100, 100)
    c = graphics.Circle(graphics.Point(50,50), 10)
    c.draw(win)
    win.getMouse() # pause for click in window
    win.close()
    
main()






# %%

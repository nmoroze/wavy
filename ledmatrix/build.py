import siliconcompiler

def main():
    chip = siliconcompiler.Chip()
    chip.set('design', 'top')
    chip.add('source', 'ledmatrix.v')
    chip.add('source', 'top.v')
    chip.set('constraint', 'icebreaker.pcf')
    chip.set('fpga', 'partname', 'ice40up5k-sg48')
    chip.load_target('fpgaflow_demo')

    chip.run()

if __name__ == '__main__':
    main()
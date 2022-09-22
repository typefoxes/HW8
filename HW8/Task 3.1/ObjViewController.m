// Задание 3.1: Текущее значение текстфилда и все предыдущие, для которых была нажата кнопка. Разделитель — пробел. Например, в поле ввели «Никита», нажали кнопку — в лейбл выведется «Никита». В поле ввели «Антон» и нажали на кнопку — в лейбл выведется «Антон Никита», и так далее.

#import "ObjViewController.h"

@interface ObjViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *btn;



@property NSString *varText;
@end

@implementation ObjViewController

- (IBAction)button:(id)sender {
    _varText = [[NSString alloc] initWithFormat: @"%@ %@",
                _textfield.text, _varText];
       _label.text = _varText;
       _textfield.text = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _varText = @"";
   
}
@end


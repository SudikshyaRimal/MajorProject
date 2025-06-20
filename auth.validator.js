
const  Joi=require('joi');
const strongPasswordPattern=/^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[\W_])[a-zA-Z\d\W]{8,25}$/
const RegisterUserDto=Joi.object({
    name:Joi.string().min(2).max(50).required(),
    email:Joi.string().email().required(),
    password:Joi.string().required().regex(strongPasswordPattern),
    confirmPassword:Joi.ref('password'),
    role:Joi.string().regex(/^(seller)|(customer)$/).optional().default("customer"),
    address:Joi.string().allow(null,"").optional().default(null),
    phone:Joi.string().allow(null,"").optional().default(null),
    gender:Joi.string().regex(/^(male)|(female)|(other)$/).required(),
    dob:Joi.date().less("now"),
    image:Joi.string().allow(null,"").optional().default(null)
});

const LoginUserDto=Joi.object({
    email:Joi.string().email().required(),
    password:Joi.string().required()
});

module.exports={RegisterUserDto,LoginUserDto};
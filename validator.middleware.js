//joi,zod,yup,ajv,class-validator packages are used for validation
const bodyValidator=(rules)=>{
    return async(req,res,next)=>{
        try{
            const payload=req.body;
            if(!payload){
                throw{code:422,
                    message:"data not provided",
                    status:"validation_failed_error"
                }
            }
            await rules.validateAsync(payload,{abortEarly:false})
            next()
        }catch(exception){
            let error={
                code:400,
                message:"Validation failed",  
                status:"validation_failed_error",
                details:{}
            }
            exception.details.map((errorObj)=>{
                let field=errorObj.path.pop()
                error.details[field]=errorObj.message
            })
            //console.error(exception) for debugging purpose and validaion error detail
            next(error)
            //next(exception)
        }

    }
}
module.exports=bodyValidator
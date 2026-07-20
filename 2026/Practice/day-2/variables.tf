variable "ssc" {
    type = map(object({
        ami_id = string
        itype= string
        iname= string
    }))
}